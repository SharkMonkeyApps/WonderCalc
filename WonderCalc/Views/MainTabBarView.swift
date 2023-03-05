//
//  MainTabBarView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/15/23.
//

import SwiftUI

struct MainTabBarView: View {
    let config: AppConfig

    var body: some View {
        TabView{
            PageView(analytics: config.analytics) { CalculatorView(calculator: Calculator(config: config)) }
                .tabItem {
                    Image(systemName: "circle.grid.3x3")
                    Text("Calculator")
                }
            PageView(analytics: config.analytics) { UnitsView(unitProvider: UnitProvider(), config: config) }
                .tabItem {
                    Image(systemName: "ruler")
                    Text("Units")
                }
            PageView(analytics: config.analytics) { LoanView(loanCalc: LoanCalculator(), config: config) }
                .tabItem {
                    Image(systemName: "percent")
                    Text("Loans")
                }
            PageView(analytics: config.analytics) { AboutView(config: config) }
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
        }
    }
}
