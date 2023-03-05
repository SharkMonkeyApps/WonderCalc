//
//  File.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 3/4/23.
//

import SwiftUI

/** A View with an analytics page track event */
struct PageView<Page>: View where Page: View {

    let page: Page
    let analytics: AnalyticsProviding

    var body: some View {
        page
            .onAppear { analytics.pageView("\(type(of: page))") }
    }

    init(analytics: AnalyticsProviding, content: @escaping (() -> Page)) {
        self.page = content()
        self.analytics = analytics
    }
}
