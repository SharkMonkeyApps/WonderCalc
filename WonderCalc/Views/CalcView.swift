//
//  ContentView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

struct CalcView: View {
    
    @ObservedObject var calculator: Calculator
    
    var body: some View {
        VStack {
            Text("\(calculator.publishedValue)")
            
            LazyVGrid(columns: layout, spacing: 10) {
                numberButton(7)
                numberButton(8)
                numberButton(9)
                operatorButton(.plus)
            }
            LazyVGrid(columns: layout, spacing: 10) {
                numberButton(4)
                numberButton(5)
                numberButton(6)
                operatorButton(.minus)
            }
            LazyVGrid(columns: layout, spacing: 10) {
                numberButton(1)
                numberButton(2)
                numberButton(3)
                operatorButton(.multiply)
            }
            LazyVGrid(columns: layout, spacing: 10) {
                numberButton(0)
                operatorButton(.divide)
                operatorButton(.equal)
                Button("C", action: { calculator.clear() })
            }
        }
        .padding()
    }
    
    // MARK: - Private
    
    private let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private func numberButton(_ number: Int) -> NumberButton {
        NumberButton(value: number, callback: calculator.numberTapped)
    }
    
    private func operatorButton(_ operand: Operand) -> OperandButton {
        OperandButton(operand: operand, callback: calculator.operandPressed)
    }
}

struct CalcView_Previews: PreviewProvider {
    static var previews: some View {
        CalcView(calculator: Calculator())
    }
}
