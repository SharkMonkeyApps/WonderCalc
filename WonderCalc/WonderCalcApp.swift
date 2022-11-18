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
                CalculatorView(calculator: Calculator())
                    .tabItem {
                        Image(systemName: "circle.grid.3x3")
                        Text("Calculator")
                    }
                UnitsView(unitProvider: UnitProvider())
                    .tabItem {
                        Image(systemName: "ruler")
                        Text("Units")
                    }
                LoanView(loanCalc: LoanCalculator())
                    .tabItem {
                        Image(systemName: "percent")
                        Text("Loans")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }
    }
}
