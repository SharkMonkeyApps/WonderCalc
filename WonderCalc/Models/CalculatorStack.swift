//
//  CalculatorStack.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/14/23.
//

import Foundation

/** A number ot math operator for use in a CalculationStack */
enum CalculableType {
    case number
    case mathOperator
}

/** Able to be appended to a CalculatorStack. Includes numbers and operators */
protocol Calculable {
    var type: CalculableType { get }
}

extension Double: Calculable { var type: CalculableType { return .number }}
extension Operator: Calculable { var type: CalculableType { return .mathOperator }}

/** A first number, a math operator, and a final number to be calculated */
typealias Calculation = (Double, Operator, Double)

/** A stack of numbers and math operators for use in calculations */
class CalculatorStack {

    /** Optionally append the item, forcing the stack to begin with a number and alternate */
    func append(_ item: Calculable) {
        if let last = stack.last {
            if last.type != item.type { stack.append(item) }
        } else if item.type == .number { stack.append(item) }
    }

    /** Reset the stack to empty */
    func clear() {
        print("clear stack")
        stack = []

    }

    /** Calculate the value of the existing stack based on order of operation. */
    func calculate(currentOp: Operator? = nil, precedence: Int = 0) throws -> Double? {

        if currentOp == nil && stack.count > 2 {
            previousCalculation = stack.suffix(2)
        } else if currentOp == nil && stack.count == 1 {
            stack.append(contentsOf: previousCalculation)
        }
        let maxPrecedence = currentOp?.precedence.rawValue ?? OperatorPrecedence.allCases.max(by: { $0.rawValue < $1.rawValue })?.rawValue ?? 1
        var finalResult: Double?

        for (index, item) in stack.enumerated() {
            if let calculation = try popCalculationIfItShouldCalculate(item: item, index: index, precedence: precedence) {
                let result = try perform(calculation: calculation)
                stack.insert(result, at: index - 1)
                finalResult = result
                break // Do not continue to loop through a mutated array
            }

            if index + 1 == stack.count && precedence != maxPrecedence && stack.count >= 3 {
                finalResult = try calculate(precedence: precedence + 1)
            }
        }
        if precedence != maxPrecedence && stack.count >= 3 {
            finalResult = try calculate(precedence: precedence + 1)
        }
        return finalResult
    }

    // MARK: - Private

    /** Numbers and operators to be performed */
    private var stack: [Calculable] = [] // Numbers and operators to be performed

    /** Performed on repeated tapping of equal */
    private var previousCalculation: [Calculable] = []

    /** Evaluates if the operator should execute based on order of operation and if the stack has a number before and after the operator.
     If the criteria are met, the stack items are destructively removed from the stack and returned. */
    private func popCalculationIfItShouldCalculate(item: Calculable, index: Int, precedence: Int) throws -> Calculation? {
        // Determine if it is safe to remove the Calculation:
        guard let mathOperator = item as? Operator,
              mathOperator.precedence.rawValue == precedence, // Ex: Don't add until after multiplication
              stack.count > index + 1, // A number follows the operator
              index >= 1 // A number precedes the operator
        else { return nil }

        // Remove the Calculation:
        guard let calculation = popCalculation(at: index - 1) else { throw CalculatorError.invalidOperation("Operator Index") }

        return calculation
    }

    private func popCalculation(at index: Int) -> Calculation? {
        guard let first = stack.remove(safe: index) as? Double,
              let op = stack.remove(safe: index) as? Operator,
              let second = stack.remove(safe: index) as? Double
        else { return nil }

        return (first, op, second)
    }

    private func perform(calculation: Calculation) throws -> Double {
        let (first, op, second) = calculation

        switch op {
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

    private func setFirstNumber(_ number: Double) {
        guard stack.first?.type == .mathOperator else { return }
        stack.insert(number, at: 0)
    }

    private func appendRepeatedPreviousCalculation() {

    }
}
