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

/** Able to be appended to a CalculatorStack */
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

    /** Optionally pop the last 2 numbers and corresponding operator if present */
    func popFinalCalculation() -> Calculation? {
        guard stack.count >= 3 && stack.last?.type == .number else { return nil }
        guard let lastNum = stack.popLast() as? Double,
              let lastOp = stack.popLast() as? Operator,
              let secondToLastNum = stack.popLast() as? Double
        else { return nil }

        return (secondToLastNum, lastOp, lastNum)
    }

    /** Reset the stack to empty */
    func clear() { stack = [] }

    /** Return the most recently appended operator */
    var lastOperator: Operator? {
        stack.last { valueOrOperand in
            guard let _ = valueOrOperand as? Operator else { return false }

            return true
        } as? Operator
    }

    // MARK: - Private

    private var stack: [Calculable] = []

}
