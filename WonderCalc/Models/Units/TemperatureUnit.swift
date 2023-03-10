//
//  TemperatureUnit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 3/10/23.
//

import Foundation

enum TemperatureUnit: String, Unitable {
    case celcius = "Celcius" // Standard
    case fahrenheight = "Fahrenheight"
    case kelvin = "Kelvin"

    var multiplier: Double {
        switch self {
        case .celcius:
            return 1
        case .fahrenheight:
            return 1.8
        case .kelvin:
            return 1
        }
    }

    var adder: Double {
        switch self {
        case .celcius:
            return 0
        case .fahrenheight:
            return 32
        case .kelvin:
            return 273.15
        }
    }

    var convertedName: String {
        switch self {
        case .celcius:
            return "℃"
        case .fahrenheight:
            return "℉"
        case .kelvin:
            return "Kelvin"
        }
    }
    static var firstOption: TemperatureUnit { .celcius }
    static var secondOption: TemperatureUnit { .fahrenheight }
}
