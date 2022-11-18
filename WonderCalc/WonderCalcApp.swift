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
                        Text("Calc")
                    }
                UnitsView(unitProvider: UnitProvider())
                    .tabItem {
                        Image(systemName: "ruler")
                        Text("Units")
                    }
            }
        }
    }
}
