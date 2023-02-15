//
//  Operator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/14/23.
//

import Foundation

/** Math Operators which are evaluated on the calculation stack rather than immediately */
enum Operator {
    /** Note: Exponents are excluded because the app has no parenthesis.
     Therefore exponents are the highest precedence and evaluate immediately.
     Additionally, exponents operate on a single value, and have different behavior */
    case multiply
    case divide
    case plus
    case minus

    init?(_ option: CalculatorButtonOption) {
        switch option {
        case .multiply:
            self = .multiply
        case .divide:
            self = .divide
        case .plus:
            self = .plus
        case .minus:
            self = .minus
        default:
            return nil
        }
    }

    var precedence: OperatorPrecedence {
        switch self {
        case .multiply, .divide:
            return .multiplyDivide
        case .plus, .minus:
            return .addSubtract
        }
    }
}

/** Handles order of operation exculding immediate execution (exponents...) */
enum OperatorPrecedence: Int, CaseIterable {
    case multiplyDivide = 0
    case addSubtract = 1
}
