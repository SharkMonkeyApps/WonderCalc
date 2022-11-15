//
//  CalculationsListView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

struct CalculationsListView: View {
    @ObservedObject var calculator: Calculator
    
    var body: some View {
        
        NavigationView {
            List(calculator.calculations) { calc in
                CalculationCell(calculation: calc)
            }
        }
    }
}

struct CalculationCell: View {
    @StateObject var calculation: Calculation
    
    var body: some View {
        
        HStack {
            TextField("", text: $calculation.stringValue)
                .keyboardType(.decimalPad)
            Spacer()
            Picker(calculation.operand.rawValue, selection: $calculation.operand, content: { ForEach(Operand.all, id: \.self) { Text($0.rawValue) } })
        }
    }
}
