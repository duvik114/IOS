import Foundation

protocol Stackable {
    associatedtype Element
    func peek() -> Element?
    func size() -> Int
    mutating func push(_ element: Element)
    @discardableResult mutating func pop() -> Element?
}

public struct Stack<String>: Stackable {
    private var storage = [String]()
    func peek() -> String? { storage.last }
    func size() -> Int { storage.count }
    mutating func push(_ element: String) { storage.append(element)  }
    mutating func pop() -> String? { storage.popLast() }
}
