//
//  MainTabBarView.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/15/23.
//

import SwiftUI

struct MainTabBarView: View {
    var body: some View {
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
            AboutView()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
        }
    }
}
