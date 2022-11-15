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
    
    static let all: [Operand] = [
        .plus, .minus, .multiply, .divide
    ]
    
    var generateCalculation: Bool {
        switch self {
        case .negative, .clear:
            return false
        default:
            return true
        }
    }
}
