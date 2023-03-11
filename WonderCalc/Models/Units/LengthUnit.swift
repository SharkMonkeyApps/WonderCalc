//
//  LengthUnit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 3/10/23.
//

import Foundation

enum LengthUnit: String, Unitable {
    case meters // Standard
    case millimeters
    case centimeters
    case kilometers
    case feet
    case inches
    case yards
    case miles

    var multiplier: Double {
        switch self {
        case .meters:
            return 1
        case .feet:
            return metersToFeet
        case .millimeters:
            return 1000
        case .centimeters:
            return 100
        case .kilometers:
            return 1 / 1000
        case .inches:
            return metersToFeet * 12
        case .yards:
            return metersToFeet / 3
        case .miles:
            return metersToFeet / 5280
        }
    }

    var adder: Double { 0 }

    static var firstOption: LengthUnit { .meters }
    static var secondOption: LengthUnit { .feet }

    private var metersToFeet: Double { 3.28084 }
}
