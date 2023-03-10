import XCTest

@testable import JobTracking

final class JobTrackingTests: XCTestCase {
    
    private let jw: JobWorker<Int, Int, Error> = { (key: Int, inFunc) -> Void in
        var kkey: Int = key * key
        for i in 1...10000000 {
            kkey += 1
        }
        inFunc(.success(kkey))
    }
    
    func testGCD() {
        var flag1: Bool = false
        var flag2: Bool = false
        var rres: Result<Int, Error> = .success(9)
        
        let gcd: GCDJobTracker = GCDJobTracker<Int, Int, Error>(memoizing: MemoizationOptions.completed, worker: jw)
        
        gcd.startJob(for: 4, completion: { (res) -> Void in
            rres = res
            flag1 = true
        })
        while !flag1 {}
        print("First done!")
        switch rres {
        case .success(let out):
            XCTAssertEqual(out, 10000016)
        case .failure(_):
            XCTFail()
        }
        
        gcd.startJob(for: 5, completion: { (res) -> Void in
            rres = res
            flag2 = true
        })
        while !flag2 {}
        print("Second done!")
        switch rres {
        case .success(let out):
            XCTAssertEqual(out, 10000025)
        case .failure(_):
            XCTFail()
        }
    }
    
    func testAsync() async throws {
        let asnc: AsyncJobTracker = AsyncJobTracker<Int, Int, Error>(memoizing: MemoizationOptions.completed, worker: jw)
        
        let res1 = try await asnc.startJob(for: 4)
        if res1 != 10000016 {
            XCTFail()
        }
        print("First done!")
        
        let res2 = try await asnc.startJob(for: 4)
        if res2 != 10000016 {
            XCTFail()
        }
        print("Second done!")
    }
    
    func testPublisher() async throws {
        let comb: CombineJobTracker = CombineJobTracker<Int, Int, Error>(memoizing: MemoizationOptions.completed, worker: jw)
        
        let publ = comb.startJob(for: 4)
        _ = publ.sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { value in
            if value != 10000016 {
                XCTFail()
            }
        })
    }
}
