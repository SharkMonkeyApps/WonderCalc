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
            MainTabBarView()
        }
    }

    init() {
        let catamaran = UIFont(name: "CatamaranRoman-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: catamaran]
    }
}
