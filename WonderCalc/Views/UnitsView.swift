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
    let config: AppConfig
    
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

                LazyVGrid(columns: layout) {
                    Spacer()
                    HStack {
                        Button(action: swapUnits) {
                            Text(Image(systemName: "rectangle.2.swap"))
                                .font(.subHeading)
                                .foregroundColor(.white)
                                .padding()
                                .background(Capsule()
                                    .fill(.indigo)
                                    .frame(height: 56))
                        }
                        Spacer()
                    }
                }
                
                PickerRow(title: "To:", options: unitProvider.units, layout: layout, selection: $unitProvider.toUnit)
                    .padding(.bottom)
                
                Spacer()
                
                Text("\(unitProvider.result.value) \(unitProvider.result.unit)")
                    .font(.heading)
                Button(action: copyResults) {
                    Text(Image(systemName: "doc.on.doc"))
                        .font(.subHeading)
                        .foregroundColor(.white)
                        .padding()
                        .background(Capsule()
                            .fill(unitProvider.result.value == "" ? .gray : .blue)
                            .frame(height: 56))
                }
                .disabled(unitProvider.result.value == "")
                
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

    private func swapUnits() {
        let newToUnit = unitProvider.fromUnit
        unitProvider.fromUnit = unitProvider.toUnit
        unitProvider.toUnit = newToUnit
    }

    private func copyResults() {
        config.pasteboard.copy(unitProvider.result.value)
    }
}
