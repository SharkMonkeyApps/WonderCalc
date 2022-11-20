//
//  TextFiledRow.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/19/22.
//

import SwiftUI

struct TextFieldRow: View {
    
    @Binding var input: String
    let title: String
    let placeHolder: String
    let keyboardType: UIKeyboardType
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subHeading)
            TextField(placeHolder, text: $input)
                .keyboardType(keyboardType)
                .textFieldStyle(.roundedBorder)
            
        }
    }
}
