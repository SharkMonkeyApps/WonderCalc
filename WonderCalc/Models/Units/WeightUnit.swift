//
//  WeightUnit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 3/10/23.
//

import Foundation

enum WeightUnit: String, Unitable {
    case grams // Standard
    case milligrams
    case kilograms
    case pounds
    case ounces
    case tons

    var multiplier: Double {
        switch self {

        case .grams:
            return 1
        case .milligrams:
            return 1000
        case .kilograms:
            return 1 / 1000
        case .pounds:
            return gramToPounds
        case .ounces:
            return gramToPounds * 16
        case .tons:
            return gramToPounds / 2000
        }
    }

    var adder: Double { 0 }

    static var firstOption: WeightUnit { .grams }
    static var secondOption: WeightUnit { .pounds }

    private var gramToPounds: Double { 1 / 453.592 }
}
