//
//  SettingsView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/18/22.
//

import SwiftUI

struct AboutView: View {
    
    let url = URL(string: "https://www.sharkmonkeyapps.com/")
    let appStoreURL = URL(string: "https://apps.apple.com/us/app/wondercalc/id6444459924")
    let config: AppConfig
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("smLogo")
                Text("This app was created by")
                if let url = url {
                    Link("SharkMonkey Apps", destination: url)
                        .padding(.bottom)
                        .font(.catamaran)
                        .environment(\.openURL, OpenURLAction { url in
                            config.analytics.log("websiteLinkTapped", options: [
                                "url": url
                            ])
                            return .systemAction
                        })
                } else {
                    Text("SkarkMonkey Apps")
                        .padding(.bottom)
                        .font(.catamaran)
                }

                Text("Please visit our website to provide feedback, or discuss your software development needs")
                    .padding(.bottom)
                    .multilineTextAlignment(.center)

                Text("Please visit the App Store to")
                if let url = appStoreURL {
                    Link("Rate this app", destination: url)
                        .font(.catamaran)
                        .environment(\.openURL, OpenURLAction { url in
                            config.analytics.log("rateAppLinkTapped", options: [
                                "url": url
                            ])
                            return .systemAction
                        })
                } else {
                    Text("Rate this app")
                        .font(.catamaran)
                }
                
                #if DEBUG
                Button("Crash") {
                  fatalError("Crash was triggered")
                }
                #endif
                
                Spacer()
                Text("© 2023 SharkMonkey Apps LLC")
            }
            .padding()
            .navigationTitle("About")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
