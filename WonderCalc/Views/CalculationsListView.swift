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
                Text("\(calc.number) \(calc.operand.rawValue)")
            }
        }
    }
}
