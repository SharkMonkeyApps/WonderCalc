//
//  NumberFormatter.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation

extension NumberFormatter {
    
    static func calculatorDecimalAndZerosString(_ number: Double, hasDecimal: Bool, zeros: Int = 0) -> String {
        let numberString = String(number)
        if numberString.suffix(2) == ".0" && hasDecimal == false {
            return String(numberString.dropLast(2))
        } else if numberString.last == "0" {
            let zerosToAddOrRemove = zeros - 1
            if zerosToAddOrRemove < 0 {
                return String(numberString.dropLast(-zerosToAddOrRemove))
            } else if zerosToAddOrRemove > 0 {
                let addedZeros = String(repeating: "0", count: zerosToAddOrRemove)
                return numberString + addedZeros
            }
        }
        return numberString
    }

    static func unitRoundedString(_ number: Double) -> String {
        let rounded = Double(round(number * 10000) / 10000)

        return "\(rounded)"
    }
    
    static func currencyString(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}
