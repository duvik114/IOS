import Foundation

public struct UnOperator<T: Numeric> {
    public let precedence: Int
    public let associativity: Associativity
    private let function: (T) throws -> T
    
    /// Конструктор с параметрами
    /// - Parameters:
    ///   - precedence: приоритет
    ///   - associativity: ассоциативность
    ///   - function: вычислимая бинарная функция
    public init(precedence: Int, associativity: Associativity, function: @escaping (T) throws -> T) {
        self.precedence = precedence
        self.associativity = associativity
        self.function = function
    }
    
    /// Применить оператор
    /// - Parameters:
    ///   - lhs: первый аргумент
    ///   - rhs: второй аргумент
    /// - Returns: результат, либо исключение
    public func apply(_ lhs: T) throws -> T {
        try self.function(lhs)
    }
}
