//
//  CalculatorButton.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/14/23.
//

import Foundation

/** Represents a unique button on the calculator with relevant associated information */
enum CalculatorButtonOption: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case decimal = "."

    // Operands + Pasteboard: Raw Value is SF Symbol Name
    case plus
    case minus
    case multiply
    case divide
    case squared = "^2" // Display text (no SF Symbol)
    case squareRoot = "x.squareroot"
    case percent
    case negative = "plus.forwardslash.minus"

    case equal

    case clear

    case cut = "scissors"
    case copy = "doc.on.doc"
    case paste = "list.clipboard"

    var type: CalculatorButtonType {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal:
            return .number
        case .clear:
            return .clear
        case .cut, .copy, .paste:
            return .pasteboard
        default:
            return .mathOperator
        }
    }
}

enum CalculatorButtonType {
    case number
    case mathOperator
    case clear
    case pasteboard
}
