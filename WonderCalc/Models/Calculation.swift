//
//  Calculation.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/15/22.
//

import Foundation

class Calculation: Identifiable, ObservableObject {
    var id: UUID
    @Published var operand: Operand
    var stringValue: String
    
    init(operand: Operand = .none) {
        self.id = UUID()
        self.stringValue = "0"
        self.operand = operand
    }
    
    var number: Double {
        Double(stringValue) ?? 0
    }
    
    func addDigit(_ digit: String) {
        // Handle decimals and zeros
        if digit == "." && hasDecimal {
            return
        } else if digit == "." {
            hasDecimal = true
        } else if hasDecimal && digit != "0" {
            zeros = 0
        } else if hasDecimal && digit == "0" {
            zeros += 1
        }
        
        if stringValue == "0" {
            stringValue = digit
        } else {
            stringValue.append(digit)
        }
    }
    
    func toggleNegative() {
        if stringValue.first == "-" {
            stringValue.removeFirst()
        } else {
            stringValue = "-" + stringValue
        }
    }

    func pasteValue(_ value: String) {
        stringValue = value
    }
    
    // MARK: - Private
    
    private var hasDecimal = false
    private var zeros = 0
}
