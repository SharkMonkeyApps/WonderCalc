//
//  VolumeUnit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 3/10/23.
//

import Foundation

enum VolumeUnit: String, Unitable {
    case liters // Standard
    case milliliters
    case gallons
    case quarts
    case pints
    case cups
    case fluidOunces = "fluid ounces"
    case tablespoon
    case teaspoon

    var multiplier: Double {
        switch self {
        case .liters:
            return 1
        case .milliliters:
            return 1000
        case .gallons:
            return literToGallon
        case .quarts:
            return 4 * literToGallon
        case .pints:
            return 8 * literToGallon
        case .cups:
            return 16 * literToGallon
        case .fluidOunces:
            return 128 * literToGallon
        case .tablespoon:
            return 256 * literToGallon
        case .teaspoon:
            return 768 * literToGallon
        }
    }

    var adder: Double { 0 }

    static var firstOption: VolumeUnit { .liters }
    static var secondOption: VolumeUnit { .gallons }

    private var literToGallon: Double { 1 / 3.78541 }
}
