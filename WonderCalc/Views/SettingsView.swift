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
                Text("This app was created by")
                if let url = url {
                    Link("SharkMonkey Apps", destination: url)
                } else {
                    Text("SkarkMonkey Apps")
                }
            }
            .padding()
            .navigationTitle("Settings")
        }
    }
}
