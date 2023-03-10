import Foundation

public class RealCalculator: Calculator {
    public typealias Number = Double
    
    private let unOperators: Dictionary<String, UnOperator<Double>> = [
        "u": UnOperator(precedence: 10, associativity: .left, function: {(i: Double) throws -> Double in
            return -i
        }),
        // http://www.wikiznanie.ru/ru-wz/index.php/Факториал_дробного_числа
        "!": UnOperator(precedence: 20, associativity: .left, function: {(i: Double) throws -> Double in
            let divMod = modf(i)
            var diiv: Int = 1
            if i == 0 {
                return 1
            }
            if i < 0 {
                throw ParsingError.parsingError("Cannot count factorial from " + String(i) + " < 0")
            }
            for f in 1...Int(divMod.0) {
                diiv *= f
            }
            return exp(log(Double(diiv)) + divMod.1 * log(divMod.0 + 1))
        }),
    ]
    
    private let calc: AbstractCalculator<Double>

    required public init(operators: Dictionary<String, Operator<Double>>) {
        self.calc = AbstractCalculator(operators: operators, unOperators: unOperators, numRegex: "[0-9]+(\\.[0-9]+)?", evalBinaryOper: {(v1: String, v2: String, op: Operator<Double>) throws -> String in
            guard let vI1 = Double(v1) else {
                throw ParsingError.parsingError("Cannot cast string " + v1 + " to double")
            }
            guard let vI2 = Double(v2) else {
                throw ParsingError.parsingError("Cannot cast string " + v2 + " to double")
            }
            return String(try op.apply(vI1, vI2))
        }, evalUnaryOper: {(v: String, op: UnOperator<Double>) throws -> String in
            guard let vI = Double(v) else {
                throw ParsingError.parsingError("Cannot cast string " + v + " to double")
            }
            return String(try op.apply(vI))
        })
    }

    public func evaluate(_ input: String) throws -> Double {
        var postfix = try calc.infixToPostfix(expr: input)
        postfix = try calc.evalPostfix(expr: postfix)
        guard let resPop = postfix.pop() else {
            throw ParsingError.parsingError("No result in stack")
        }
        guard let res = Double(resPop) else {
            throw ParsingError.parsingError("Cannot cast result to double: incorrect result " + resPop)
        }
        return res
    }
}
