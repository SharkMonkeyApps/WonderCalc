//
//  Calculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation
import UniformTypeIdentifiers
import UIKit

/** Recieves user input to create or update calculations, and performs those calculations to publish a result */
class Calculator: ObservableObject {
    
    /** Result value displayed on the calculator's output */
    @Published var publishedValue: String = "0"
    
    /** Received user input from button tapped for 0-9 or decimal point to construct a number value */
    func numberTapped(_ number: String) {
        currentCalculation.addDigit(number)
        publish(currentCalculation.stringValue)
    }
    
    /** Received user input requesting to perform an operand on the numerical values */
    func operandTapped(_ operand: Operand) {
        guard operand.generateCalculation else {
            performNonCalculationOperand(operand)
            return
        }
        calculations.append(currentCalculation)
        currentCalculation = Calculation(operand: operand)
        tryCalculations(finalOperand: operand)
    }

    func pasteboardTapped(_ option: PasteboardOption) {
        switch option {
        case .cut:
            UIPasteboard.general.string = publishedValue
            clear()
        case .copy:
            UIPasteboard.general.string = publishedValue
        case .paste:
            if let contents = UIPasteboard.general.string,
               let value  = Double(contents) {
                currentCalculation.pasteValue(format(value))
                publish(currentCalculation.stringValue)
            }
        }
    }
    
    /** The numerical values and operands entered or updated by the user which can be iterated to produce result */
    var calculations: [Calculation] = []
    
    // MARK: - Private
    
    /** Calculation holding the value the user has entered which has not been entered into the stored calculations */
    private var currentCalculation = Calculation()
    
    private func performNonCalculationOperand(_ operand: Operand) {
        switch operand {
        case .clear:
            clear()
        case .negative:
            currentCalculation.toggleNegative()
            publish(currentCalculation.stringValue)
        case .equal:
            tryCalculations(includeCurrentValue: true)
        default:
            break
        }
    }
    
    private func tryCalculations(includeCurrentValue: Bool = false, finalOperand: Operand? = nil) {
        do {
            let result = try calculate(includeCurrentValue: includeCurrentValue)
            if let finalOperand = finalOperand, finalOperand.performCalculationImmediately {
                let newResult = try perform(initialValue: result, operand: finalOperand, newValue: nil)
                publish(newResult)
            } else {
                publish(result)
            }
        } catch {
            handle(error)
        }
    }
    
    private func calculate(includeCurrentValue: Bool) throws -> Double {
        let calculationsToPerform = includeCurrentValue ? calculations + [currentCalculation] : calculations
        var value: Double = 0 // result from previous calculation
        
        for calc in calculationsToPerform {
            if calc.operand == .none {
                value = calc.number
                continue
            }

            let result = try perform(initialValue: value, operand: calc.operand, newValue: calc.number)
            value = result
        }
        
        return value
    }
    
    private func perform(initialValue: Double, operand: Operand, newValue: Double?) throws -> Double {

        switch operand {
        case .plus:
            return initialValue + (newValue ?? 0)
        case .minus:
            return initialValue - (newValue ?? 0)
        case .multiply:
            return initialValue * (newValue ?? 1)
        case .divide:
            if newValue != 0 {
                return initialValue / (newValue ?? 1)
            } else {
                throw CalculatorError.divByZero
            }
        case .percent:
            return initialValue / 100
        case .squared:
            return initialValue * initialValue
        case .squareRoot:
            return sqrt(initialValue)
        case .clear, .negative, .equal, .none:
            // Handled by nonCalculatingOperand
            throw CalculatorError.invalidOperation
        }
    }

    private func format(_ number: Double) -> String {
        NumberFormatter.calculatorDecimalAndZerosString(number, hasDecimal: false)
    }
    
    private func publish(_ number: Double) {
        publish(format(number))
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
        case .invalidOperation, .missingArgument:
            publish("Error")
        }
    }
    
    private func clear() {
        calculations = []
        currentCalculation = Calculation()
        publish(currentCalculation.stringValue)
    }
}

enum CalculatorError: Error {
    case divByZero
    case invalidOperation
    case missingArgument
}
