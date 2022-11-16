//
//  Operand.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/15/22.
//

import Foundation

enum Operand: String {
    case plus = "+"
    case minus = "-"
    case multiply = "X"
    case divide = "/"
    case equal = "="
    case negative = "+/-"
    case percent = "%"
    case squared = "^2"
    case clear = "C"
    case none
    
    static let all: [Operand] = [
        .plus, .minus, .multiply, .divide
    ]
    
    /** Operands that should be added to calculation record */
    var generateCalculation: Bool {
        switch self {
        case .negative, .clear, .equal, .none:
            return false
        default:
            return true
        }
    }
    
    /** Operands that act on previous values only */
    var performCalculationImmediately: Bool {
        switch self {
        case .squared, .percent:
            return true
        default:
            return false
        }
    }
}
