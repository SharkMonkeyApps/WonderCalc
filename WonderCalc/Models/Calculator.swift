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
extension Operator: Calculable { }

/** Recieves user input to create or update calculations, and performs those calculations to publish a result */
class Calculator: ObservableObject {

    /** Result value displayed on the calculator's output */
    @Published var publishedValue: String = "0"

    /** Receives user input from the view */
    func buttonTapped(_ option: CalculatorButtonOption) {
        switch option.type {
        case .number:
            numberTapped(option)
        case .mathOperator:
            operatorTapped(option)
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
        set { currentStringValue = format(newValue) }
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

    private func operatorTapped(_ option: CalculatorButtonOption) {
        guard option.type == .mathOperator else { return invalidOperation("Invalid Operand") }

        print("Op: \(option.rawValue)")

        switch option {
            // Calculate Immediately:
        case .equal:
            calculationStack.append(currentNumber)
            calculateStack()
        case .negative:
            currentNumber = currentNumber * -1.0
            publishCurrentValue()
        case .percent:
            currentNumber = currentNumber / 100.0
            publishCurrentValue()
        case .squared:
            currentNumber = currentNumber * currentNumber
            publishCurrentValue()
        case .squareRoot:
            currentNumber = sqrt(currentNumber)
            publishCurrentValue()
        default: // Evaluate based on Stack:
            guard let currentOperator = Operator(option) else { return }
            calculationStack.append(currentNumber)
            currentNumber = 0
            calculateAndAddToStack(currentOperator)
        }
    }

    private func pasteboardOptionTapped(_ option: CalculatorButtonOption) {
        // TODO: - Mock + Test pasteboard
        print("Pb: \(option.rawValue)")
        switch option {
        case .cut:
            UIPasteboard.general.string = publishedValue
            clearCurrentValue()
        case .copy:
            UIPasteboard.general.string = publishedValue
        case .paste:
            if let contents = UIPasteboard.general.string,
               let value  = Double(contents) {
                currentNumber = value
                publishCurrentValue()
            }
        default:
            invalidOperation("Invalid Pasteboard option")
        }
    }

    private func clearButtonTapped() {
        // TODO: - Handle AC/C
        clearCurrentValue()
        calculationStack = []
    }

    private func decimalTapped() {
        guard currentStringValue.contains(".") == false else { return }

        currentStringValue.append(".")
        publishCurrentValue()
    }

    // MARK: - Publish Helpers

    private func publishCurrentValue() {
        publish(currentNumber)
    }

    private func publish(_ number: Double) {
        publish(format(number))
    }

    private func publish(_ value: String) {
        publishedValue = value
    }

    // MARK: - Calculations

    private func calculateStack() {
        guard let result = popAndCalculateFromStack() else { return }

        calculationStack.append(result)
        publish(result)
        currentNumber = 0
    }

    private func calculateAndAddToStack(_ currentOperator: Operator) {
        if currentOperator.precedence.rawValue <= lastOperator?.precedence.rawValue ?? 0,
           let result = popAndCalculateFromStack() {
            publish(result)
            calculationStack.append(result)
            calculationStack.append(currentOperator)
            currentNumber = 0
        } else {
            // TODO: - Validate
            calculationStack.append(currentOperator)
        }
    }

    func popAndCalculateFromStack() -> Double? {
        guard let lastNum = calculationStack.popLast() as? Double,
              let lastOp = calculationStack.popLast() as? Operator,
              let secondToLastNum = calculationStack.popLast() as? Double
        else { return nil }

        return perform(first: secondToLastNum, currentOperator: lastOp, second: lastNum)
    }

    private func perform(first: Double, currentOperator: Operator, second: Double) -> Double {
        switch currentOperator {
        case .multiply:
            return first * second
        case .divide:
            return first / second
        case .plus:
            return first + second
        case .minus:
            return first - second
        }
    }

    // MARK: - Stack Helpers

    private var lastOperator: Operator? {
        calculationStack.last { valueOrOperand in
            guard let _ = valueOrOperand as? Operator else { return false }

            return true
        } as? Operator
    }

    // MARK: - Clear Helpers

    private func clearCurrentValue() {
        currentStringValue = "0"
        publishCurrentValue()
    }

    // MARK: - Formatting Helpers

    private func format(_ number: Double) -> String {
        NumberFormatter.calculatorDecimalAndZerosString(number, hasDecimal: false)
    }

    // MARK: - Error Helpers

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
        case .invalidOperation:
            publish("Error")
        }
    }
}

enum CalculatorError: Error {
    case divByZero
    case invalidOperation(_ message: String)
}
