//
//  PickerRow.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/19/22.
//

import SwiftUI

struct PickerRow<Option: Pickable>: View {
    let title: String
    let options: [Option]
    @Binding var selection: Option
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subHeading)
            Spacer()
            Picker(title, selection: $selection, content: {
                ForEach(options, id: \.self) {
                    Text($0.name)
                }
            }).pickerStyle(.menu)
        }
    }
}

protocol Pickable: Hashable {
    var name: String { get }
}

extension Pickable where Self: RawRepresentable<String> {
    var name: String { rawValue }
}
