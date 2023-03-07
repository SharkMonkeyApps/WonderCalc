//
//  NumberFormatter.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation

extension NumberFormatter {
    
    static func calculatorDecimalAndZerosString(_ number: Double, hasDecimal: Bool, zeros: Int = 0) -> String {
        var result: String = ""
        let numberString = String(number)
        if number > 9999999999999000 { // Scientific Notation
            return scientificFormatter.string(from: NSNumber(value: number)) ?? ""
        } else if numberString.suffix(2) == ".0" && hasDecimal == false { // Integers
            result = String(numberString.dropLast(2))
        } else if numberString.last == "0" { // Correct Number of Zeros displayed
            let zerosToAddOrRemove = zeros - 1
            if zerosToAddOrRemove < 0 {
                result = String(numberString.dropLast(-zerosToAddOrRemove))
            } else if zerosToAddOrRemove > 0 {
                let addedZeros = String(repeating: "0", count: zerosToAddOrRemove)
                result = numberString + addedZeros
            }
        } else {
            result = numberString
        }

        // Add Commas
        let components = result.split(separator: ".")
        if let beforeDecimal = Int(components.first ?? ""),
           let numberWithCommas = decimalFormatter.string(from: NSNumber(value: beforeDecimal)),
           let negative = Double(beforeDecimal) > number ? "-" : "" { // -0 becomes 0

            if components.count > 1,
               let afterDecimal = components.last {
                return negative + numberWithCommas + "." + afterDecimal
            } else if result.last == "." {
                return negative + numberWithCommas + "."
            } else {
                return negative + numberWithCommas
            }
        }

        return numberString
    }

    static func unitRoundedString(_ number: Double) -> String {
        let rounded = Double(round(number * 10000) / 10000)
        if abs(rounded) > 0.0 {
            return "\(rounded)"
        } else {
            return "\(number)"
        }
    }

    static func currencyString(_ number: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: number)) ?? ""
    }

    static func currencyNumber(from string: String) -> Double? {
        currencyFormatter.number(from: string) as? Double
    }

    // MARK: - Private

    private static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }()

    private static let currencyFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        return formatter
    }()

    private static let scientificFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 12
        formatter.exponentSymbol = "e"

        return formatter
    }()
}
