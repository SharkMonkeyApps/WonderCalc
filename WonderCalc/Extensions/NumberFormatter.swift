//
//  NumberFormatter.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation

extension NumberFormatter {
    
    func string(from number: Double) -> String? {
        string(from: NSNumber(floatLiteral: number))
    }
    
    static let calculatorDisplay: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        
        return formatter
    }()
}
