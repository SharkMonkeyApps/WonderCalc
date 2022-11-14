//
//  NumberButton.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

struct NumberButton: View {
    let value: String
    let callback: (String) -> ()
    
    func returnValue() {
        callback(value)
    }
    
    var body: some View {
        Button(action: returnValue) {
            Text("\(value)")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule()
                    .fill(.orange)
                    .frame(height: 56))
        }
    }
}
