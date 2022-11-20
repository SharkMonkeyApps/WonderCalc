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
            Text(operand.rawValue)
                .font(.subHeading)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule()
                    .fill(Color.green)
                    .frame(height: 56))
        }
    }
}
