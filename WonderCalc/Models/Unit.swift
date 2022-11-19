//
//  Unit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/16/22.
//

import Foundation
import Combine

class UnitProvider: ObservableObject {
    @Published var selectedType: UnitType = .length {
        didSet {
            units = selectedType.units
        }
    }
    
    @Published var units: [Unit] = LengthUnit.allUnits
    
    @Published var fromUnit: Unit = LengthUnit.feet.unit
    @Published var toUnit: Unit = LengthUnit.meters.unit
    
    @Published var fromValue: String = ""
    
    @Published var result: String = ""
    
    init() {
        Publishers.CombineLatest3($fromUnit, $toUnit, $fromValue)
            .map { _ in self.calculatedResult }
            .assign(to: &$result)
    }
    
    private var calculatedResult: String {
        guard let fromQuantity = Double(fromValue) else { return "" }
        
        let standardQuantity: Double = fromUnit.toStandardUnit(fromQuantity)
        let resultQuantity: Double = toUnit.fromStandardUnit(standardQuantity)
        
        return NumberFormatter.calculatorDecimalAndZerosString(resultQuantity, hasDecimal: false) + " \(toUnit.name)"
    }
}

enum UnitType: String, Pickable, CaseIterable {
    
    case length
    case temperature
    case weight
    case volume
    
    var units: [Unit] {
        switch self {
        case .length:
            return LengthUnit.allUnits
        case .temperature:
            return TemperatureUnit.allUnits
        case .weight:
            return WeightUnit.allUnits
        case .volume:
            return VolumeUnit.allUnits
        }
    }
}

enum VolumeUnit: String, Unitable {
    case liters // Standard
    case milliliters
    case gallons
    case quarts
    case pints
    case cups
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
        case .tablespoon:
            return 256 * literToGallon
        case .teaspoon:
            return 768 * literToGallon
        }
    }
    
    var adder: Double { 0 }
    
    private var literToGallon: Double { 1 / 3.78541 }
}

enum WeightUnit: String, Unitable {
    case grams // Standard
    case milligrams
    case kilograms
    case pounds
    case ounces
    
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
            return gramToPounds / 16
        }
    }
    
    var adder: Double { 0 }
    
    private var gramToPounds: Double { 1 / 453.592 }
}

enum LengthUnit: String, Unitable {
    case meters // Standard
    case millimeters
    case centimeters
    case kilometers
    case feet
    case inches
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
        case .miles:
            return metersToFeet / 5280
        }
    }
    
    var adder: Double { 0 }
    
    private var metersToFeet: Double { 3.28 }
}

enum TemperatureUnit: String, Unitable {
    case celcius // Standard
    case fahrenheight
    case kelvin
    
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
            return -273.15
        }
    }
}

protocol Unitable: CaseIterable {
    static var allUnits: [Unit] { get }
    var unit: Unit { get }
    var rawValue: String { get }
    func toStandardUnit(_ value: Double) -> Double
    func fromStandardUnit(_ value: Double) -> Double
    var multiplier: Double { get }
    var adder: Double { get }
}

extension Unitable {
    var unit: Unit { Unit(unit: self) }
    
    static var allUnits: [Unit] {
        allCases.map({ $0.unit })
    }
    
    func fromStandardUnit(_ value: Double) -> Double {
        (value * multiplier) + adder
    }
    
    func toStandardUnit(_ value: Double) -> Double {
        (value - adder) / multiplier
    }
}

struct Unit: Pickable {
    
    let unit: any Unitable
    var name: String { unit.rawValue }
    
    func toStandardUnit(_ value: Double) -> Double {
        unit.toStandardUnit(value)
    }
    
    func fromStandardUnit(_ value: Double) -> Double {
        unit.fromStandardUnit(value)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(unit.rawValue)
    }
    
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        lhs.unit.rawValue == rhs.unit.rawValue
    }
}
