//
//  CalculatorButton.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/14/23.
//

import SwiftUI

struct CalculatorButton: View {
    let option: CalculatorButtonOption
    let callback: (CalculatorButtonOption) -> ()

    func returnValue() {
        callback(option)
    }

    var body: some View {
        Button(action: returnValue) {
            option.text
                .font(.subHeading)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule()
                    .fill(option.color)
                    .frame(height: 56))
        }
    }
}

extension CalculatorButtonOption {
    var text: Text {
        switch self.type {
        case .number:
            return Text(rawValue)
        case .operand, .pasteboard:
            if self == .squared { // No SF Symbol for squared
                return Text(rawValue)
            }
            return Text(Image(systemName: rawValue))
        case .clear:
            // TODO: - Support AC
            return Text("C")
        }
    }

    var color: Color {
        switch self.type {
        case .number:
            return .orange
        case .operand:
            return .green
        case .clear:
            return .red
        case .pasteboard:
            return .blue
        }
    }
}
