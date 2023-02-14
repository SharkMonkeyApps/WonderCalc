//
//  Operator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/14/23.
//

import Foundation

/** Math Operators which are evaluated on the calculation stack rather than immediately */
enum Operator {
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

    var precedence: OperandPrecedence {
        switch self {
        case .multiply, .divide:
            return .multiplyDivide
        case .plus, .minus:
            return .addSubtract
        }
    }
}

/** Handles order of operation exculding immediate execution (exponents...) */
enum OperandPrecedence: Int, CaseIterable {
    case multiplyDivide = 2
    case addSubtract = 1
}
