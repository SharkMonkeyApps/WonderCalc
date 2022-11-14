//
//  NumberButton.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

struct NumberButton: View {
    let value: Int
    let callback: (Int) -> ()
    
    func returnValue() {
        callback(value)
    }
    
    var body: some View {
        Button(action: returnValue) {
            Text("\(value)")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule()
                    .fill(Color.orange)
                    .frame(height: 50))
        }
    }
}
