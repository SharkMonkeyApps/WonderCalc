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
                    .padding(.bottom)
                
                HStack {
                    TextField("", text: $unitProvider.fromValue)
                        .keyboardType(.decimalPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                        )
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Unit", selection: $unitProvider.fromUnit, content: {
                        ForEach(unitProvider.units, id: \.self) {
                            Text($0.name)
                        }
                    }).pickerStyle(.menu)
                }
                .padding(.bottom)
                
                PickerRow(title: "To", options: unitProvider.units, selection: $unitProvider.toUnit)
                    .padding(.bottom)
                
                Spacer()
                
                Text(unitProvider.result)
                    .font(.heading)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Unit Conversion")
        }
        .dismissKeyboardOnTap()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
