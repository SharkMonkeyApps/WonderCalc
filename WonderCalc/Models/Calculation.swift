//
//  Calculation.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/15/22.
//

import Foundation

class Calculation: Identifiable, ObservableObject {
    var id: UUID
    @Published var number: Double
    @Published var operand: Operand
    
    init(number: Double, operand: Operand) {
        self.id = UUID()
        self.number = number
        self.operand = operand
    }
    
    var stringValue: String {
        get {
            String(number)
        }
        set {
            number = Double(newValue) ?? 0
        }
    }
}
