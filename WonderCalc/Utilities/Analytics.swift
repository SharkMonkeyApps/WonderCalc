//
//  Analytics.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 3/3/23.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics

protocol AnalyticsProviding {
    func configure()
    func log(_ message: String, options: [String: Any]?)
    func pageView(_ name: String)
}

extension AnalyticsProviding {
    func log(_ message: String, options: [String: Any]? = nil) {
        log(message, options: options)
    }
}

struct FirebaseAnalytics: AnalyticsProviding {
    func pageView(_ name: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: name
        ])
    }

    func log(_ message: String, options: [String : Any]?) {
        Analytics.logEvent(message, parameters: options)
    }

    func configure() {
        FirebaseApp.configure()
    }
}

struct NoAnalytics: AnalyticsProviding {
    func pageView(_ name: String) {

    }

    func configure() { }
}

struct NoPasteboard: PasteBoardable {
    func copy(_ value: String) { }
    func paste() -> String? { return nil }
}

struct AppConfig {
    let analytics: AnalyticsProviding
    let pasteboard: PasteBoardable

    static var empty: AppConfig {
        AppConfig(
            analytics: NoAnalytics(),
            pasteboard: NoPasteboard()
        )
    }
}
