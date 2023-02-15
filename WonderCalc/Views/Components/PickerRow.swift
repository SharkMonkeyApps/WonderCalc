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
    let layout: [GridItem]
    @Binding var selection: Option
    
    var body: some View {
        LazyVGrid(columns: layout) {
            HStack {
                Spacer()
                Text(title)
                    .font(.subHeading)
            }
            HStack {
                Picker(title, selection: $selection, content: {
                    ForEach(options, id: \.self) {
                        Text($0.name)
                            .font(.subHeading)
                    }
                }).pickerStyle(.menu)
                    .font(.subHeading)
                Spacer()
            }
        }
    }
}

protocol Pickable: Hashable {
    var name: String { get }
}

extension Pickable where Self: RawRepresentable<String> {
    var name: String { rawValue }
}
