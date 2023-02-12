//
//  PasteboardButton.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/12/23.
//

import SwiftUI

enum PasteboardOption: String {
    case cut = "scissors"
    case copy = "doc.on.doc"
    case paste = "list.clipboard"

    var image: Image { Image(systemName: rawValue) }
}

struct PasteboardButton: View {
    let option: PasteboardOption
    let callback: (PasteboardOption) -> ()

    func returnOperand() {
        callback(option)
    }

    var body: some View {
        Button(action: returnOperand) {
            Text(option.image)
                .font(.subHeading)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule()
                    .fill(Color.blue)
                    .frame(height: 56))
        }
    }
}
