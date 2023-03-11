//
//  Calculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation

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

    /** Text to display on clear button: AC or C */
    @Published var clearButtonText: String = "AC"

    init(config: AppConfig) {
        self.config = config
    }

    // MARK: - Private

    private var currentStringValue: String = "0"
    private var shouldAppend = false
    private var calculatorStack = CalculatorStack()
    private let config: AppConfig
    private var lastInstantCalculation: CalculatorButtonOption?

    private var currentNumber: Double {
        get { Double(currentStringValue.replacingOccurrences(of: ",", with: "")) ?? 0.0 }
        set { currentStringValue = format(newValue) }
    }

    private var currentPublishedNumber: Double {
        Double(publishedValue.replacingOccurrences(of: ",", with: "")) ?? 0.0
    }

    // MARK: - Button Tap Handlers

    private func numberTapped(_ option: CalculatorButtonOption) {
        guard option.type == .number else { return invalidOperation("Invalid Number") }

        lastInstantCalculation = nil

        if shouldAppend == false {
            currentStringValue = "0"
            shouldAppend = true
        }

        if option == .decimal {
            decimalTapped()
        } else if shouldAppend == false {
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
            lastInstantCalculation = .percent
            handleInstantCalculation(result: currentPublishedNumber / 100.0)
        case .squared:
            guard currentPublishedNumber < largestSquarableNumber else { return resultTooLarge() }
            lastInstantCalculation = .squared
            handleInstantCalculation(result: currentPublishedNumber * currentPublishedNumber)
        case .squareRoot:
            lastInstantCalculation = .squareRoot
            handleInstantCalculation(result: sqrt(currentPublishedNumber))
        default: // Evaluate based on Stack:
            guard let currentOperator = Operator(option) else { return }
            lastInstantCalculation = nil
            calculatorStack.append(currentNumber)
            clearCurrentValue()
            calculateAndAddToStack(currentOperator)
        }
    }

    private func handleInstantCalculation(result: Double) {
        currentNumber = result
        shouldAppend = false
        publishCurrentNumber()
    }

    private func pasteboardOptionTapped(_ option: CalculatorButtonOption) {
        switch option {
        case .cut:
            config.pasteboard.copy(publishedValue)
            clearCurrentValue(publish: true)
        case .copy:
            config.pasteboard.copy(publishedValue)
        case .paste:
            if let contents = config.pasteboard.paste(),
               let value  = Double(contents) {
                currentNumber = value
                publishCurrentNumber()
            }
        default:
            invalidOperation("Invalid Pasteboard option")
        }
    }

    private func equalPressed() {
        if shouldAppend {
            calculatorStack.append(currentNumber)
        } else if let lastOp = lastInstantCalculation {
            operatorTapped(lastOp)
        }

        do {
            if let result = try calculatorStack.calculate() {
                currentNumber = result
                shouldAppend = false

                publishCurrentNumber()
            }
        } catch {
            handle(error)
        }
    }

    private func clearButtonTapped() {
        if shouldClearAll {
            calculatorStack.clear()
        }
        clearCurrentValue(publish: true)
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
        clearButtonText = shouldClearAll ? "AC" : "C"
    }

    // MARK: - Calculations

    private func calculateAndAddToStack(_ currentOperator: Operator) {
        if let result = try? calculatorStack.calculate(currentOp: currentOperator) {
            publish(result)
            calculatorStack.append(result)
            calculatorStack.append(currentOperator)
            clearCurrentValue()
        } else {
            calculatorStack.append(currentOperator)
        }
    }

    // MARK: - Clear Helpers

    private var shouldClearAll: Bool {
        publishedValue == "0"
    }

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

    private func resultTooLarge() {
        let error = CalculatorError.tooLarge
        handle(error)
    }
    
    private func handle(_ error: Error, line: Int = #line) {
        guard let calcError = error as? CalculatorError else {
            publish("Error")
            config.analytics.log("undeterminedCalculatorError", options: [
                "line": line,
                "description": error.localizedDescription
            ])
            return
        }
        
        switch calcError {
        case .divByZero:
            publish("Can't divide by zero")
        case .tooLarge:
            publish("Too large to calculate")
        case .invalidOperation(let message):
            publish("Error")
            config.analytics.log("invalidCalculatorOperation", options: [
                "message": message
            ])
        }
    }

    // MARK: - Constant halpers

    private lazy var largestSquarableNumber: Double = {
        sqrt(Double.greatestFiniteMagnitude)
    }()
}

enum CalculatorError: Error {
    case divByZero
    case tooLarge
    case invalidOperation(_ message: String)
}
