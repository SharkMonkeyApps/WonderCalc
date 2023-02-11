//
//  SettingsView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/18/22.
//

import SwiftUI

struct SettingsView: View {
    
    let url = URL(string: "https://www.sharkmonkeyapps.com/")
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("This app was created by")
                if let url = url {
                    Link("SharkMonkey Apps", destination: url)
                } else {
                    Text("SkarkMonkey Apps")
                }
                Spacer()
                Text("Copyright 2023 SharkMonkey Apps LLC")
            }
            .padding()
            .navigationTitle("Settings")
        }
    }
}
