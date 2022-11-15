//
//  Calculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation

/** Recieves user input to create or update calculations, and performs those calculations to publish a result */
class Calculator: ObservableObject {
    
    /** Result value displayed on the calculator's output */
    @Published var publishedValue: String = "0"
    
    /** Received user input from button tapped for 0-9 or decimal point to construct a number value */
    func numberTapped(_ number: String) {
        if currentValue == "0" {
            currentValue = number
        } else {
            currentValue.append(number)
        }
        
        publish(currentValue)
    }
    
    /** Received user input requesting to perform an operand on the numerical values */
    func operandTapped(_ operand: Operand) {
        guard operand.generateCalculation else {
            performNonCalculatedOperand(operand)
            return
        }
        
        let calculation = Calculation(number: doubleValue, operand: operand)
        calculations.append(calculation)
        do {
            try calculate()
        } catch {
            handle(error)
        }
    }

    /** The numerical values and operands entered or updated by the user which can be iterated to produce result */
    var calculations: [Calculation] = []
    
    // MARK: - Private
    
    /** Value the user is currently entering which has not been entered into a calculation */
    private var currentValue: String = "0"
    
    private var doubleValue: Double { Double(currentValue) ?? 0 }
    
    private func performNonCalculatedOperand(_ operand: Operand) {
        switch operand {
        case .clear:
            clear()
        case .negative:
            if currentValue.hasPrefix("-") {
                currentValue.removeFirst()
            } else {
                currentValue = "-" + currentValue
            }
            publish(currentValue)
        default:
            break
        }
    }
    
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
        case .percent:
            return initialValue / 100
        case .squared:
            return initialValue * initialValue
        case .clear, .negative:
            // Handled by nonCalculatingOperand
            throw CalculatorError.invalidOperation
        }
    }
    
    private func publish(_ value: Double, rounded: Bool = false) {
        let stringValue = NumberFormatter.calculatorDisplay.string(from: value) ?? ""
        if rounded && stringValue.suffix(2) == ".0" {
            publish(String(stringValue.dropLast(2)))
        } else {
            publish(stringValue)
        }
    }
    
    private func publish(_ value: String) {
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
        case .invalidOperation:
            publish("Error")
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
    case invalidOperation
}
