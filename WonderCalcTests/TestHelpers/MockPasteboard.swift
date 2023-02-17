//
//  MockPasteboard.swift
//  WonderCalcTests
//
//  Created by Steven Schwedt on 2/17/23.
//

import Foundation
@testable import WonderCalc

class MockPasteboard: PasteBoardable {
    func copy(_ value: String) {
        contents = value
    }

    func paste() -> String? {
        contents
    }

    private var contents: String?
}
