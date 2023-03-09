//
//  Unit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/16/22.
//

import Foundation
import Combine

class UnitProvider: ObservableObject {
    fileprivate typealias InputValues = (fromValue: String, fromUnit: Unit, toUnit: Unit)
    typealias UnitResult = (value: String, unit: String)

    
    @Published var category: UnitType = .length {
        didSet {
            units = category.units
            fromUnit = category.firstOption
            toUnit = category.secondOption
        }
    }
    
    @Published var units: [Unit] = LengthUnit.allUnits
    
    @Published var fromUnit: Unit = LengthUnit.feet.unit
    @Published var toUnit: Unit = LengthUnit.meters.unit
    
    @Published var fromValue: String = ""
    
    @Published var result: UnitResult = ("", "")
    
    init() {
        Publishers.CombineLatest3($fromValue, $fromUnit, $toUnit)
            .map { values in self.calculatedResult(values) }
            .assign(to: &$result)
    }
    
    private func calculatedResult(_ values: InputValues) -> UnitResult {
        guard let fromQuantity = Double(values.fromValue) else { return ("", "") }
        
        let standardQuantity: Double = values.fromUnit.toStandardUnit(fromQuantity)
        let resultQuantity: Double = values.toUnit.fromStandardUnit(standardQuantity)
        
        return (NumberFormatter.unitRoundedString(resultQuantity), values.toUnit.convertedName)
    }
}

enum UnitType: String, Pickable, CaseIterable {
    case area
    case length
    case temperature
    case time
    case volume
    case weight
    
    var units: [Unit] { type.allUnits }
    var firstOption: Unit { type.firstOption.unit }
    var secondOption: Unit { type.secondOption.unit }
    
    private var type: any Unitable.Type {
        switch self {
        case .length:
            return LengthUnit.self
        case .temperature:
            return TemperatureUnit.self
        case .time:
            return TimeUnit.self
        case .weight:
            return WeightUnit.self
        case .volume:
            return VolumeUnit.self
        case .area:
            return AreaUnit.self
        }
    }
}

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

enum VolumeUnit: String, Unitable {
    case liters // Standard
    case milliliters
    case gallons
    case quarts
    case pints
    case cups
    case ounces
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
        case .ounces:
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

protocol Unitable: CaseIterable {
    static var allUnits: [Unit] { get }
    var unit: Unit { get }
    var rawValue: String { get }
    func toStandardUnit(_ value: Double) -> Double
    func fromStandardUnit(_ value: Double) -> Double
    var multiplier: Double { get }
    var adder: Double { get }
    var convertedName: String { get }
    static var firstOption: Self { get }
    static var secondOption: Self { get }
}

extension Unitable {
    var unit: Unit { Unit(unit: self) }
    var convertedName: String { rawValue }
    
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
    var convertedName: String { unit.convertedName }
    
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
