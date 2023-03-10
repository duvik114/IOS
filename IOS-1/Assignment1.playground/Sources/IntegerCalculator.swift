import Foundation

public class IntegerCalculator: Calculator {
    public typealias Number = Int

    private let unOperators: Dictionary<String, UnOperator<Int>> = [
        "u": UnOperator(precedence: 10, associativity: .left, function: {(i: Int) throws -> Int in
            return -i
        }),
        "!": UnOperator(precedence: 20, associativity: .left, function: {(i: Int) throws -> Int in
            var res: Int = 1
            if i == 0 {
                return 1
            }
            if i < 0 {
                throw ParsingError.parsingError("Cannot count factorial from " + String(i) + " < 0")
            }
            for f in 1...i {
                res *= f
            }
            return res
        }),
    ]
    
    private let calc: AbstractCalculator<Int>

    required public init(operators: Dictionary<String, Operator<Int>>) {
        self.calc = AbstractCalculator(operators: operators, unOperators: unOperators, numRegex: "[0-9]+", evalBinaryOper: {(v1: String, v2: String, op: Operator<Int>) throws -> String in
            guard let vI1 = Int(v1) else {
                throw ParsingError.parsingError("Cannot cast string " + v1 + " to int")
            }
            guard let vI2 = Int(v2) else {
                throw ParsingError.parsingError("Cannot cast string " + v2 + " to int")
            }
            return String(try op.apply(vI1, vI2))
        }, evalUnaryOper: {(v: String, op: UnOperator<Int>) throws -> String in
            guard let vI = Int(v) else {
                throw ParsingError.parsingError("Cannot cast string " + v + " to int")
            }
            return String(try op.apply(vI))
        })
    }

    public func evaluate(_ input: String) throws -> Int {
        var postfix = try calc.infixToPostfix(expr: input)
        postfix = try calc.evalPostfix(expr: postfix)
        guard let resPop = postfix.pop() else {
            throw ParsingError.parsingError("No result in stack")
        }
        guard let res = Int(resPop) else {
            throw ParsingError.parsingError("Cannot cast result to int: incorrect result " + resPop)
        }
        return res
    }
}
