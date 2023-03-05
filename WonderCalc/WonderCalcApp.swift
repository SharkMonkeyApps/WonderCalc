//
//  WonderCalcApp.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/14/22.
//

import SwiftUI

@main
struct WonderCalcApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MainTabBarView(config: config)
        }
    }

    init() {
        self.delegate.config = config
    }

    // MARK: - Private

    private let config = AppConfig(
        analytics: FirebaseAnalytics(),
        pasteboard: PasteBoard.standard
    )
}


class AppDelegate: NSObject, UIApplicationDelegate {

    var config: AppConfig?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupAnalytics()
        styleNavBar()

        return true
    }

    // MARK: - Private

    private func setupAnalytics() {
        config?.analytics.configure()
    }

    private func styleNavBar() {
        let catamaran = UIFont(name: "CatamaranRoman-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: catamaran]
    }
}
