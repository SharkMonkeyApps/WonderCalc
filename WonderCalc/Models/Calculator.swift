//
//  Calculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation
import UniformTypeIdentifiers
import UIKit

protocol Calculable {

}

extension Double: Calculable { }
extension CalculatorButtonOption: Calculable { }

/** Recieves user input to create or update calculations, and performs those calculations to publish a result */
class Calculator: ObservableObject {

    /** Result value displayed on the calculator's output */
    @Published var publishedValue: String = "0"

    /** Receives user input from the view */
    func buttonTapped(_ option: CalculatorButtonOption) {
        switch option.type {
        case .number:
            numberTapped(option)
        case .operand:
            operandTapped(option)
        case .clear:
            clearButtonTapped()
        case .pasteboard:
            pasteboardOptionTapped(option)
        }
    }

    // MARK: - Private

    private var currentStringValue: String = "0"
    private var calculationStack: [Calculable] = []

    private var currentNumber: Double {
        get { Double(currentStringValue) ?? 0.0 }
        set { currentStringValue = "\(newValue)" }
    }

    // MARK: - Button Tap Handlers

    private func numberTapped(_ option: CalculatorButtonOption) {
        guard option.type == .number else { return invalidOperation("Invalid Number") }

        if option == .decimal {
            decimalTapped()
        } else if currentStringValue == "0" {
            currentStringValue = option.rawValue
            publishCurrentValue()
        } else {
            currentStringValue.append(option.rawValue)
            publishCurrentValue()
        }
    }

    private func operandTapped(_ option: CalculatorButtonOption) {
        guard option.type == .operand else { return invalidOperation("Invalid Operand") }

        print("Op: \(option.rawValue)")

        switch option {
        case .equal:
            calculateStack()
        case .negative:
            currentNumber = currentNumber * -1.0
            publishCurrentValue()
        case .percent:
            currentNumber = currentNumber / 100.0
            publishCurrentValue()
        default:
            calculationStack.append(currentNumber)
            currentNumber = 0
            calculateOrAddToStack(option)
        }
    }

    private func pasteboardOptionTapped(_ option: CalculatorButtonOption) {
        // TODO: - Mock + Test pasteboard
        print("Pb: \(option.rawValue)")
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
        default:
            invalidOperation("Invalid Pasteboard option")
        }
    }

    private func clearButtonTapped() {
        // TODO: - Handle AC
        currentStringValue = "0"
        publishCurrentValue()
    }

    private func decimalTapped() {
        guard currentStringValue.contains(".") == false else { return }

        currentStringValue.append(".")
        publishCurrentValue()
    }

    // MARK: - Publish Helpers

    private func publishCurrentValue() {
        publish(currentStringValue)
    }

    // MARK: - Calculations

    private func calculateStack() {

    }

    private func calculateOrAddToStack(_ option: CalculatorButtonOption) {

    }

    // MARK: - Stack Helpers

    private var lastOperand: CalculatorButtonOption? {
        calculationStack.last { valueOrOperand in
            guard let operand = valueOrOperand as? CalculatorButtonOption,
                  operand.type == .operand
            else { return false }

            return true
        } as? CalculatorButtonOption
    }

    /** Received user input from button tapped for 0-9 or decimal point to construct a number value */
//    func numberTapped(_ number: String) {
//        currentCalculation.addDigit(number)
//        publish(currentCalculation.stringValue)
//    }
//
//    /** Received user input requesting to perform an operand on the numerical values */
//    func operandTapped(_ operand: Operand) {
//        guard operand.generateCalculation else {
//            performNonCalculationOperand(operand)
//            return
//        }
//        calculations.append(currentCalculation)
//        currentCalculation = Calculation(operand: operand)
//        tryCalculations(finalOperand: operand)
//    }
//
//    func pasteboardTapped(_ option: PasteboardOption) {
//        switch option {
//        case .cut:
//            UIPasteboard.general.string = publishedValue
//            clear()
//        case .copy:
//            UIPasteboard.general.string = publishedValue
//        case .paste:
//            if let contents = UIPasteboard.general.string,
//               let value  = Double(contents) {
//                currentCalculation.pasteValue(format(value))
//                publish(currentCalculation.stringValue)
//            }
//        }
//    }

    /** The numerical values and operands entered or updated by the user which can be iterated to produce result */
    var calculations: [Calculation] = []

    
    /** Calculation holding the value the user has entered which has not been entered into the stored calculations */
    private var currentCalculation = Calculation()
    
    private func performNonCalculationOperand(_ operand: Operand) {
        switch operand {
        case .clear:
            clear()
        case .negative:
            guard currentCalculation.operand.performCalculationImmediately == false else {
                currentCalculation.multiplier = currentCalculation.multiplier * -1
                tryCalculations(includeCurrentValue: true)
                return
            }

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

            let result = try perform(initialValue: value, operand: calc.operand, newValue: calc.number, multiplier: calc.multiplier)
            value = result
        }
        
        return value
    }
    
    private func perform(initialValue: Double, operand: Operand, newValue: Double?, multiplier: Int = 1) throws -> Double {

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
            return initialValue / 100 * Double(multiplier)
        case .squared:
            return initialValue * initialValue * Double(multiplier)
        case .squareRoot:
            return sqrt(initialValue) * Double(multiplier)
        case .clear, .negative, .equal, .none:
            // Handled by nonCalculatingOperand
            throw CalculatorError.invalidOperation("Calculation failed")
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

    private func invalidOperation(_ message: String, line: Int = #line) {
        let error = CalculatorError.invalidOperation("\(message): \(line)")
        handle(error)
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
    case invalidOperation(_ message: String)
    case missingArgument
}
