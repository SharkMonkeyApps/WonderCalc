//
//  File.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/16/22.
//

import SwiftUI

struct UnitsView: View {
    
    @ObservedObject var unitProvider: UnitProvider
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Type")
                Picker("Category", selection: $unitProvider.selectedType, content: {
                    ForEach(UnitType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                })
                
                Text("From")
                TextField("", text: $unitProvider.fromValue)
                    .keyboardType(.decimalPad)
                    .padding(5)
                    .border(.black)
                    .cornerRadius(10)
                Picker("Unit", selection: $unitProvider.fromUnit, content: {
                    ForEach(unitProvider.units, id: \.self) {
                        Text($0.name)
                    }
                })
                
                Text("To")
                Picker("Unit", selection: $unitProvider.toUnit, content: {
                    ForEach(unitProvider.units, id: \.self) {
                        Text($0.name)
                    }
                })
                
                Text(unitProvider.result)
            }
            .padding()
            .navigationTitle("Unit Conversion")
        }
    }
}
