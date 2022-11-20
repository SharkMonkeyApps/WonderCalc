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
                PickerRow(title: "Category", options: UnitType.allCases, selection: $unitProvider.category)
                
                HStack {
                    TextField("", text: $unitProvider.fromValue)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Unit", selection: $unitProvider.fromUnit, content: {
                        ForEach(unitProvider.units, id: \.self) {
                            Text($0.name)
                        }
                    }).pickerStyle(.menu)
                }
                
                PickerRow(title: "To", options: unitProvider.units, selection: $unitProvider.toUnit)
                
                Spacer()
                
                Text(unitProvider.result)
                    .font(.heading)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Unit Conversion")
        }
        .dismissKeyboardOnTap()
    }
}
