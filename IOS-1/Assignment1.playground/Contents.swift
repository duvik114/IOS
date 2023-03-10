import Cocoa
import Foundation
/*:
 
 # IOS @ ITMO 2022
 ## ДЗ №1
 ### Написать калькулятор
 1. Создать два типа IntegralCalculator и RealCalculator
 2. Поддержать для них протокол Calculator с типами Int и Double соответственно

 ### Бонус
 За удвоенные баллы:
 1. Поддержать унарный минус
 2. Поддержать скобки
 
 ### Критерии оценки
 0. Общая рациональность
 1. Корректность
 2. Красота и качество кода
*/

// Пример использования
func testInt(calculator type: (some Calculator<Int>).Type) {
    let calculator = type.init(operators: [
        "+": Operator(precedence: 10, associativity: .left, function: +),
        "-": Operator(precedence: 10, associativity: .left, function: -),
        "*": Operator(precedence: 20, associativity: .left, function: *),
        "/": Operator(precedence: 20, associativity: .left, function: /),
    ])
    
    let result1 = try! calculator.evaluate("2 + 2 * 2 + 2 / 2")
    print(result1)
    assert(result1 == 7)

    let result2 = try! calculator.evaluate("2 + 2 * (2 + 2 / 2)")
    print(result2)
    assert(result2 == 8)

    let result3 = try! calculator.evaluate("2 + u10 / 10")
    print(result3)
    assert(result3 == 1)

    let result4 = try! calculator.evaluate("u2 + u(u2 / 2 * (1 + 1)) + 0")
    print(result4)
    assert(result4 == 0)

    let result5 = try! calculator.evaluate("u15*(7-(1+1))*3-(2+(1+1))*15-(7-(200+1))*3-(2+(1+1))+(15+(7-(1+1))*3-(2+(1+1)))")
    print(result5)
    assert(result5 == 319)

    let result6 = try! calculator.evaluate("2-2-2")
    print(result6)
    assert(result6 == -2)
    
    let result7 = try! calculator.evaluate("!4-2-2")
    print(result7)
    assert(result7 == 20)
}

func testDouble(calculator type: (some Calculator<Double>).Type) {
    let calculator = type.init(operators: [
        "+": Operator(precedence: 10, associativity: .left, function: +),
        "-": Operator(precedence: 10, associativity: .left, function: -),
        "*": Operator(precedence: 20, associativity: .left, function: *),
        "/": Operator(precedence: 20, associativity: .left, function: /),
    ])
    
    let result1 = try! calculator.evaluate("2.0 + 2.1 * 2.8 + 2.8 / 2.0")
    print(result1)
    assert(result1 == 9.28)

    let result2 = try! calculator.evaluate("1 + 0.4 * (0.0 + 0 / 21)")
    print(result2)
    assert(result2 == 1)

    let result3 = try! calculator.evaluate("232 + u10.123 / 122220")
    print(result3)
    assert(result3 == 231.99991717394863)

    let result4 = try! calculator.evaluate("u2102931 + u(u2123 / 223.3 * (1.33333 + 1.3333333)) + 0.000000001")
    print(result4)
    assert(result4 == -2102905.6469942406)
    
    let result5 = try! calculator.evaluate("u15*(7-(1+1))*3-(2+(1+1))/15-(7-(200+1))*3-(2+(1+1))+(15/(7-(1+1))*3-(2+(1+1)))")
    print(result5)
    assert(result5 == 357.73333333333335)
    
    let result6 = try! calculator.evaluate("3.0-2.9-2.1")
    print(result6)
    assert(result6 == -2)
    
    let result7 = try! calculator.evaluate("!4.9")
    print(round(result7 * 10000) / 10000.0)
    assert(round(result7 * 10000) / 10000.0 == 102.1608)
}

func testAssociativityInt(calculator type: (some Calculator<Int>).Type) {
    let calculator = type.init(operators: [
        "-": Operator(precedence: 10, associativity: .right, function: -)
    ])
    
    let result6 = try! calculator.evaluate("2-2-2")
    print(result6)
    assert(result6 == 2)
}

func testAssociativityDouble(calculator type: (some Calculator<Double>).Type) {
    let calculator = type.init(operators: [
        "-": Operator(precedence: 10, associativity: .right, function: -)
    ])
    
    let result6 = try! calculator.evaluate("2.1-3.0-2.9")
    print(result6)
    assert(result6 == 2)
}

print("Int testing: ")
testInt(calculator: IntegerCalculator.self)
testAssociativityInt(calculator: IntegerCalculator.self)
print()
print("Double testing: ")
testDouble(calculator: RealCalculator.self)
testAssociativityDouble(calculator: RealCalculator.self)
