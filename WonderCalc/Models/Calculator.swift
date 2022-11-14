//
//  Calculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation

enum Operand: String {
    case plus = "+"
    case minus = "-"
    case multiply = "X"
    case divide = "/"
    case equal = "="
    case negative = "+/-"
    case percent = "%"
    case squared = "^2"
    case clear = "C"
}

struct Calculation: Identifiable {
    var id: String
    let number: Double
    let operand: Operand
}


class Calculator: ObservableObject {
    @Published var publishedValue: String = "0"
    
    func numberTapped(_ number: String) {
        if currentValue == "0" {
            currentValue = number
        } else {
            currentValue.append(number)
        }
        
        publish(currentValue)
    }
    
    func operandPressed(_ operand: Operand) {
        guard operand != .clear else { clear(); return }
        
        let calculation = Calculation(id: UUID().uuidString, number: doubleValue, operand: operand) // = (doubleValue, operand)
        calculations.append(calculation)
        do {
            try calculate()
        } catch {
            handle(error)
        }
    }

    var calculations: [Calculation] = []
    
    // MARK: - Private
    
    private var currentValue: String = "0"
    
    private var doubleValue: Double { Double(currentValue) ?? 0 }
    
    
    private func calculate() throws {
        var value: Double = 0
        var operand: Operand = .plus
        
        for calc in calculations {
            if value == 0 {
                value = calc.number
                operand = calc.operand
            } else {
                let result = try perform(initialValue: value, operand: operand, newValue: calc.number)
                value = result
                operand = calc.operand
            }
        }
        print("calculated")
        publish(value, rounded: true)
        currentValue = "0"
    }
    
    private func perform(initialValue: Double, operand: Operand, newValue: Double) throws -> Double {
        switch operand {
        case .plus:
            return initialValue + newValue
        case .minus:
            return initialValue - newValue
        case .multiply:
            return initialValue * newValue
        case .divide:
            if newValue != 0 {
                return initialValue / newValue
            } else {
                throw CalculatorError.divByZero
            }
        case .equal:
            return initialValue
        case .negative:
            return initialValue * -1
        case .percent:
            return initialValue / 100
        case .squared:
            return initialValue * initialValue
        case .clear:
            return 0
        }
    }
    
    private func publish(_ value: Double, rounded: Bool = false) {
        let stringValue = NumberFormatter.calculatorDisplay.string(from: value) ?? ""
        if rounded && stringValue.suffix(2) == ".0" {
            publish(String(stringValue.dropLast(2)))
            print("rounding")
        } else {
            publish(stringValue)
        }
    }
    
    private func publish(_ value: String) {
        print(value)
        publishedValue = value
    }
    
    private func handle(_ error: Error) {
        guard let calcError = error as? CalculatorError else {
            publish("Error")
            return
        }
        
        switch calcError {
        case .divByZero:
            publish("Can't divide by zero")
        }
    }
    
    private func clear() {
        calculations = []
        currentValue = "0"
        publish(currentValue)
    }
}

enum CalculatorError: Error {
    case divByZero
}
