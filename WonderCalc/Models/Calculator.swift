//
//  Calculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation
import UIKit // TODO: - Remove

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
    private var calculatorStack = CalculatorStack()

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
            publishCurrentNumber()
        } else {
            if option == .zero && hasDecimal {
                zerosAfterDecimal += 1
            } else {
                zerosAfterDecimal = 0
            }
            currentStringValue.append(option.rawValue)
            publishCurrentNumber()
        }
    }

    private func operatorTapped(_ option: CalculatorButtonOption) {
        guard option.type == .mathOperator else { return invalidOperation("Invalid Operand") }

        print("Op: \(option.rawValue)")

        switch option {
            // Calculate Immediately:
        case .equal:
            calculatorStack.append(currentNumber)
            calculateStack()
        case .negative:
            currentNumber = currentNumber * -1.0
            publishCurrentNumber()
        case .percent:
            currentNumber = currentNumber / 100.0
            publishCurrentNumber()
        case .squared:
            currentNumber = currentNumber * currentNumber
            publishCurrentNumber()
        case .squareRoot:
            currentNumber = sqrt(currentNumber)
            publishCurrentNumber()
        default: // Evaluate based on Stack:
            guard let currentOperator = Operator(option) else { return }
            calculatorStack.append(currentNumber)
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
            clearCurrentValue(publish: true)
        case .copy:
            UIPasteboard.general.string = publishedValue
        case .paste:
            if let contents = UIPasteboard.general.string,
               let value  = Double(contents) {
                currentNumber = value
                publishCurrentNumber()
            }
        default:
            invalidOperation("Invalid Pasteboard option")
        }
    }

    private func clearButtonTapped() {
        // TODO: - Handle AC/C
        clearCurrentValue(publish: true)
        calculatorStack.clear()
    }

    private func decimalTapped() {
        guard currentStringValue.contains(".") == false else { return }

        currentStringValue.append(".")
        hasDecimal = true
        publishCurrentNumber()
    }

    // MARK: - Publish Helpers

    private func publishCurrentNumber() {
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

        calculatorStack.append(result)
        publish(result)
        clearCurrentValue()
    }

    private func calculateAndAddToStack(_ currentOperator: Operator) {
        if currentOperator.precedence.rawValue <= calculatorStack.lastOperator?.precedence.rawValue ?? 0,
           let result = popAndCalculateFromStack() {
            publish(result)
            calculatorStack.append(result)
            calculatorStack.append(currentOperator)
            clearCurrentValue()
        } else {
            calculatorStack.append(currentOperator)
        }
    }

    func popAndCalculateFromStack() -> Double? {
        guard let (first, op, second) = calculatorStack.popFinalCalculation() else { return nil }

        do {
            return try perform(first: first, currentOperator: op, second: second)
        } catch {
            handle(error)
            return nil
        }
    }

    private func perform(first: Double, currentOperator: Operator, second: Double) throws -> Double {
        switch currentOperator {
        case .multiply:
            return first * second
        case .divide:
            if second == 0 { throw CalculatorError.divByZero }
            return first / second
        case .plus:
            return first + second
        case .minus:
            return first - second
        }
    }

    // MARK: - Clear Helpers

    private func clearCurrentValue(publish: Bool = false) {
        currentStringValue = "0"
        hasDecimal = false
        zerosAfterDecimal = 0
        if publish { publishCurrentNumber() }
    }

    // MARK: - Formatting Helpers

    private var hasDecimal = false
    private var zerosAfterDecimal = 0

    private func format(_ number: Double) -> String {
        NumberFormatter.calculatorDecimalAndZerosString(number, hasDecimal: hasDecimal, zeros: zerosAfterDecimal)
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
