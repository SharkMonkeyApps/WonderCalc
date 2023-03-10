//
//  AreaUnit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 3/10/23.
//

import Foundation

enum AreaUnit: String, Unitable {
    case squareMeters = "square meters" // standard
    case squareKilometers = "square kilometers"
    case squareInches = "square inches"
    case squareFeet = "square feet"
    case squareMiles = "square miles"
    case acres

    var multiplier: Double {
        switch self {
        case .squareMeters:
            return 1
        case .squareKilometers:
            return 1 / 1000000
        case .squareInches:
            return sqMeterToInch
        case .squareFeet:
            return sqMeterToInch / 144
        case .squareMiles:
            return sqMeterToInch / pow(5280 * 12, 2)
        case .acres:
            return sqMeterToInch / (pow(5280 * 12, 2) / 640)
        }
    }

    var adder: Double { 0.0 }

    static var firstOption: AreaUnit { .squareMeters }
    static var secondOption: AreaUnit { .squareFeet }

    private var sqMeterToInch: Double { 1550.0031 }
}
