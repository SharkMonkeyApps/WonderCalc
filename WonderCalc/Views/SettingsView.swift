//
//  SettingsView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/18/22.
//

import SwiftUI

struct SettingsView: View {
    
    let url = URL(string: "https://www.sharkmonkeyapps.com/")
    let appStoreURL = URL(string: "https://apps.apple.com/us/app/wondercalc/id6444459924")
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("This app was created by")
                if let url = url {
                    Link("SharkMonkey Apps", destination: url)
                        .padding(.bottom)
                } else {
                    Text("SkarkMonkey Apps")
                        .padding(.bottom)
                }

                Text("Please visit our website to provide feedback, or discuss your software development needs")
                    .padding(.bottom)

                Text("Please visit the App Store to")
                if let url = appStoreURL {
                    Link("Rate this app", destination: url)
                } else {
                    Text("Rate this app")
                }
                
                Spacer()
                Text("Copyright 2023 SharkMonkey Apps LLC")
            }
            .padding()
            .navigationTitle("About")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
