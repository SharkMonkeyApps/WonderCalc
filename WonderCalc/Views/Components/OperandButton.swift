//
//  OperandButton.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

struct OperandButton: View {
    let operand: Operand
    let callback: (Operand) -> ()
    
    func returnOperand() {
        callback(operand)
    }
    
    var body: some View {
        Button(action: returnOperand) {
            text
                .font(.subHeading)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule()
                    .fill(color)
                    .frame(height: 56))
        }
    }

    private var text: Text {
        switch operand {
        case .squared, .clear:
            return Text(operand.rawValue)
        default:
            return Text(Image(systemName: operand.rawValue))
        }
    }

    private var color: Color {
        switch operand {
        case .clear:
            return .red
        default:
            return .green
        }
    }
}
