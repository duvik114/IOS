//
//  GCDJobTracker.swift
//
//
//  Created by mac on 19.11.2022.
//

import Foundation
import Combine

public class CombineJobTracker<Key: Hashable, Output, Failure: Error>: PublishingJobTracking {
    public typealias JobPublisher = PassthroughSubject<Output, Failure>
    let memoizing: MemoizationOptions
    let worker: JobWorker<Key, Output, Failure>
    var dict: [Key: JobPublisher] = [:]
    let globalAsync = DispatchQueue(label: "CombineAsyncQueue", attributes: .concurrent)
    let globalSync = DispatchQueue(label: "CombineSyncQueue")
    public required init(memoizing: MemoizationOptions, worker: @escaping JobWorker<Key, Output, Failure>) {
        self.memoizing = memoizing
        self.worker = worker
    }
    
    public func startJob(for key: Key) -> JobPublisher {
        globalSync.sync {
            if memoizing.contains(.started) {
                if let jPublisher = dict[key] {
                    return jPublisher
                } else {
                    let jPublisher = JobPublisher()
                    dict[key] = jPublisher
                    globalAsync.async {
                        self.worker(key, { (res) -> Void in
                            switch res {
                            case .success(let out):
                                if self.memoizing.contains(.succeeded) {
                                    jPublisher.send(out)
                                }
                            case .failure(let err):
                                if self.memoizing.contains(.failed) {
                                    jPublisher.send(completion: .failure(err))
                                }
                            }
                        })
                    }
                    return jPublisher
                }
            } else {
                let jPublisher = JobPublisher()
                globalAsync.async {
                    self.worker(key, { (res) -> Void in
                        switch res {
                        case .success(let out):
                            jPublisher.send(out)
                        case .failure(let err):
                            jPublisher.send(completion: .failure(err))
                        }
                    })
                }
                return jPublisher
            }
        }
    }
}
