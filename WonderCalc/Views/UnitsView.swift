//
//  File.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/16/22.
//

import SwiftUI

struct UnitsView: View {
    
    @ObservedObject var unitProvider: UnitProvider
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationView {
            VStack {
                PickerRow(title: "Category:", options: UnitType.allCases, layout: layout, selection: $unitProvider.category)
                    .padding(.bottom)
                
                LazyVGrid(columns: layout) {
                    TextField("", text: $unitProvider.fromValue)
                        .keyboardType(.decimalPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                        )
                        .textFieldStyle(.roundedBorder)
                    HStack {
                        Picker("Unit", selection: $unitProvider.fromUnit, content: {
                            ForEach(unitProvider.units, id: \.self) {
                                Text($0.name)
                            }
                        }).pickerStyle(.menu)
                        Spacer()
                    }
                }
                .padding(.bottom)
                
                PickerRow(title: "To:", options: unitProvider.units, layout: layout, selection: $unitProvider.toUnit)
                    .padding(.bottom)
                
                Spacer()
                
                Text(unitProvider.result)
                    .font(.heading)
                
                Spacer()
            }
            .padding(horizontalSizeClass == .regular ? .wide : .standard)
            .navigationTitle("Unit Conversion")
        }
        .dismissKeyboardOnTap()
        .navigationViewStyle(StackNavigationViewStyle())
    }
    // MARK: - Private

    private let layout = [
        GridItem(.flexible()),
        GridItem(.fixed(160))
    ]
}
