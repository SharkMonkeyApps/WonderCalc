//
//  Calculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation
import UIKit // TODO: - Remove

/** Recieves user input from button taps to evaluate, calculate, and publish a result string. */
class Calculator: ObservableObject {

    /** Result value which can be used to display on a calculator's output */
    @Published var publishedValue: String = "0"

    /** Receives user input from the calculator view */
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


        switch option {
            // Calculate Immediately:
        case .equal:
            equalPressed()
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
            print("Appending: \(currentNumber) Op: \(currentOperator)")
            calculatorStack.append(currentNumber)
            clearCurrentValue()
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

    private func equalPressed() {
        print("Equal")
        calculatorStack.append(currentNumber)
        do {
            if let result = try calculatorStack.calculate() {
                currentNumber = result
                publishCurrentNumber()
            }
        } catch {
            handle(error)
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
        print("Publishing: \(value)")
        publishedValue = value
    }

    // MARK: - Calculations

    private func calculateAndAddToStack(_ currentOperator: Operator) {
        print("cAAS")
        if let result = try? calculatorStack.calculate(currentOp: currentOperator) {
            print(currentOperator)
            publish(result)
            calculatorStack.append(result)
            calculatorStack.append(currentOperator)
            clearCurrentValue()
        } else {
            calculatorStack.append(currentOperator)
        }
    }

    // MARK: - Clear Helpers

    private func clearCurrentValue(publish: Bool = false) {
        hasDecimal = false
        zerosAfterDecimal = 0
        currentNumber = 0
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
