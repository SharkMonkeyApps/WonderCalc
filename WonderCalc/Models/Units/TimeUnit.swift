//
//  TimeUnit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 3/10/23.
//

import Foundation

enum TimeUnit: String, Unitable {

    case seconds // Standard
    case minutes
    case hours
    case days
    case weeks
    case years

    var multiplier: Double {
        switch self {
        case .seconds:
            return 1
        case .minutes:
            return 1 / 60
        case .hours:
            return 1 / (60 * 60)
        case .days:
            return 1 / (60 * 60 * 24)
        case .weeks:
            return 1 / (60 * 60 * 24 * 7)
        case .years:
            return 1 / (60 * 60 * 24 * 7 * 365)
        }

    }

    var adder: Double { 0 }

    static var firstOption: TimeUnit { .seconds }
    static var secondOption: TimeUnit { .hours }
}
