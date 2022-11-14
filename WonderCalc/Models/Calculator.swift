//
//  Calculator.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import Foundation

enum Operand: String {
    case plus = "+"
    case minus = "-"
    case multiply = "X"
    case divide = "/"
    case equal = "="
}

class Calculator: ObservableObject {
    @Published var publishedValue: Int = 0
    
    func numberTapped(_ number: Int) {
        if currentValue == 0 {
            currentValue = number
        } else {
            let stringValue = "\(currentValue)\(number)"
            currentValue = Int(stringValue) ?? 0
        }
        
        publish()
    }
    
    func operandPressed(_ mathOperator: Operand) {
        let calculation: Calculation = (currentValue, mathOperator)
        calculations.append(calculation)
        calculate()
    }
    
    func clear() {
        calculations = []
        currentValue = 0
        publish()
    }
    
    // MARK: - Private
    
    private var currentValue = 0
    
    private typealias Calculation = (num: Int, oper: Operand)
    
    private var calculations: [Calculation] = []

    private func calculate() {
        var value = 0
        var operand: Operand = .plus
        
        for calc in calculations {
            if value == 0 {
                value = calc.num
                operand = calc.oper
            } else {
                let result = perform(initialValue: value, operand: operand, newValue: calc.num)
                value = result
                operand = calc.oper
            }
        }
        
        publishedValue = value
        currentValue = 0
    }
    
    private func perform(initialValue: Int, operand: Operand, newValue: Int) -> Int {
        switch operand {
        case .plus:
            return initialValue + newValue
        case .minus:
            return initialValue - newValue
        case .multiply:
            return initialValue * newValue
        case .divide:
            if newValue != 0 {
                return initialValue / newValue
            } else {
                return 0
            }
        case .equal:
            return initialValue
        }
    }
    
    private func publish() {
        publishedValue = currentValue
    }
}

