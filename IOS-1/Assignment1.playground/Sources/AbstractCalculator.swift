import Foundation

public enum ParsingError: Error {
    case parsingError(String)
}

public class AbstractCalculator<T: Numeric> {

    private var operators: Dictionary<String, Operator<T>>
    private var unOperators: Dictionary<String, UnOperator<T>>
    private let numRegex: String
    private let evalBinaryOper: (_ v1: String, _ v2: String, _ op: Operator<T>) throws -> String
    private let evalUnaryOper: (_ v: String, _ op: UnOperator<T>) throws -> String

    required public init(operators: Dictionary<String, Operator<T>>, unOperators: Dictionary<String, UnOperator<T>>, numRegex: String, evalBinaryOper: @escaping (_ v1: String, _ v2: String, _ op: Operator<T>) throws -> String, evalUnaryOper: @escaping (_ v: String, _ op: UnOperator<T>) throws -> String) {
        self.operators = operators
        self.unOperators = unOperators
        self.numRegex = numRegex
        self.evalBinaryOper = evalBinaryOper
        self.evalUnaryOper = evalUnaryOper
    }

    public func infixToPostfix(expr: String) throws -> Stack<String> {
        var postfix = Stack<String>()
        var stack = Stack<String>()
        let infix = setSpace(expr: expr).components(separatedBy: " ")
        var prevStr = ""
        var i: Int = 0
        for str in infix {
            if str.range(of: numRegex, options: .regularExpression) != nil {
                if prevStr.range(of: numRegex, options: .regularExpression) != nil || prevStr == ")" {
                    throw ParsingError.parsingError("Cannot parse your expression: missing operator at pos " + String(i) + " " + str)
                }
                postfix.push(str)
            } else {
                if str == "(" {
                    if prevStr.range(of: numRegex, options: .regularExpression) != nil || prevStr == ")" {
                        throw ParsingError.parsingError("Cannot parse your expression: missing operator at pos " + String(i))
                    }
                    stack.push(str)
                } else if str == ")" {
                    if operators[prevStr] != nil || unOperators[prevStr] != nil {
                        throw ParsingError.parsingError("Cannot parse your expression: missing number at pos " + String(i))
                    }
                    if prevStr == "(" {
                        throw ParsingError.parsingError("Cannot parse your expression: missing expression at pos " + String(i))
                    }
                    while stack.size() > 0 && (stack.peek() != "(") {
                        postfix.push(stack.pop()!)
                    }
                    guard let _ = stack.pop() else {
                        throw ParsingError.parsingError("Cannot parse your expression: missing '('")
                    }
                } else if let op = operators[str] {
                    if operators[prevStr] != nil || unOperators[prevStr] != nil || prevStr == "(" {
                        throw ParsingError.parsingError("Cannot parse your expression: missing number at pos " + String(i))
                    }
                    while checkOperator(postfix: postfix, stack: stack, op: op, str: str) {
                        postfix.push(stack.pop()!)
                    }
                    stack.push(str)
                } else if let op = unOperators[str] {
                    if prevStr.range(of: numRegex, options: .regularExpression) != nil || prevStr == ")" {
                        throw ParsingError.parsingError("Cannot parse your expression: missing operator at pos " + String(i))
                    }
                    while checkUnOperator(postfix: postfix, stack: stack, op: op, str: str) {
                        postfix.push(stack.pop()!)
                    }
                    stack.push(str)
                } else {
                    throw ParsingError.parsingError("Cannot parse your expression: invalid token at pos " + String(i))
                }
            }
            prevStr = str
            i += str.count
        }
        while stack.size() > 0 {
            if stack.peek()! == "(" {
                throw ParsingError.parsingError("Cannot parse your expression: missing )")
            }
            postfix.push(stack.pop()!)
        }
        return postfix
    }
    
    private func setSpace(expr: String) -> String {
        var exprModified = expr
        for op in operators.keys {
            exprModified = exprModified.replacingOccurrences(of: op, with: " " + op + " ")
        }
        for op in unOperators.keys {
            exprModified = exprModified.replacingOccurrences(of: op, with: " " + op + " ")
        }
        exprModified = exprModified.replacingOccurrences(of: "(", with: " ( ")
        exprModified = exprModified.replacingOccurrences(of: ")", with: " ) ")
        exprModified = " " + exprModified + " "
        let components = exprModified.components(separatedBy: .whitespacesAndNewlines)
        exprModified = components.filter { !$0.isEmpty }.joined(separator: " ")
        return exprModified
    }
    
    private func checkOperator(postfix: Stack<String>, stack: Stack<String>, op: Operator<T>, str: String) -> Bool {
        return stack.size() > 0
            && (
                ((operators[stack.peek()!] != nil)
                 && (
                    ((operators[stack.peek()!]!.precedence >= op.precedence) && (operators[stack.peek()!]!.associativity == .left || operators[stack.peek()!]!.associativity == .none))
                    || (
                        (
                            (operators[stack.peek()!]!.precedence > op.precedence)
                            || ((operators[stack.peek()!]!.precedence == op.precedence) && (stack.peek()! != str))
                        )
                        && (operators[stack.peek()!]!.associativity == .right)
                    )
                 )
                )
                || (unOperators[stack.peek()!] != nil)
            )
    }
    
    private func checkUnOperator(postfix: Stack<String>, stack: Stack<String>, op: UnOperator<T>, str: String) -> Bool {
        return stack.size() > 0
            && (unOperators[stack.peek()!] != nil)
            && (
                ((unOperators[stack.peek()!]!.precedence >= op.precedence) && (unOperators[stack.peek()!]!.associativity == .left || unOperators[stack.peek()!]!.associativity == .none))
                || ((
                        (unOperators[stack.peek()!]!.precedence > op.precedence)
                        || ((unOperators[stack.peek()!]!.precedence == op.precedence) && (stack.peek()! != str))
                    )
                    && (unOperators[stack.peek()!]!.associativity == .right))
            )
    }

    public func evalPostfix(expr: Stack<String>) throws -> Stack<String> {
        var postfix = expr

        guard let str = postfix.pop() else {
            throw ParsingError.parsingError("Wrong postfix expression: empty stack!")
        }
        if let op = operators[String(str)] {
            postfix = try evalPostfix(expr: postfix)
            guard let v1 = postfix.pop() else {
                throw ParsingError.parsingError("Wrong postfix expression: missing first operand for operator " + str)
            }
            postfix = try evalPostfix(expr: postfix)
            guard let v2 = postfix.pop() else {
                throw ParsingError.parsingError("Wrong postfix expression: missing second operand for operator " + str)
            }
            try postfix.push(evalBinaryOper(v2, v1, op))
        } else if let op = unOperators[String(str)] {
            postfix = try evalPostfix(expr: postfix)
            guard let vStr = postfix.pop() else {
                throw ParsingError.parsingError("Wrong postfix expression: missing operand for operator " + str)
            }
            try postfix.push(evalUnaryOper(vStr, op))
        } else {
            postfix.push(str)
        }
        return postfix
    }
}
