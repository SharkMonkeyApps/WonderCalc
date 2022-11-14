//
//  WonderCalcApp.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

@main
struct WonderCalcApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
                CalcView(calculator: Calculator())
                    .tabItem {
                        Image(systemName: "centsign.circle")
                        Text("Calc")
                    }
            }
        }
    }
}
