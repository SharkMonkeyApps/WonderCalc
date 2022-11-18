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
    @Published var toUnit: Unit = LengthUnit.meter.unit
    
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
        
        return String(resultQuantity)
    }
}

enum UnitType: String, CaseIterable {
    case length
    case temperature
    
    var units: [Unit] {
        switch self {
        case .length:
            return LengthUnit.allUnits
        case .temperature:
            return TemperatureUnit.allUnits
        }
    }
}

enum LengthUnit: String, Unitable {
    case feet
    case meter // Standard
    
    func toStandardUnit(_ value: Double) -> Double {
        switch self {
        case .feet:
            return value * 0.304878
        case .meter:
            return value
        }
    }
    
    func fromStandardUnit(_ value: Double) -> Double {
        switch self {
        case .feet:
            return value * 3.28
        case .meter:
            return value
        }
    }
}

enum TemperatureUnit: String, Unitable {
    case celcius // Standard
    case fahrenheight
    
    func toStandardUnit(_ value: Double) -> Double {
        switch self {
        case .celcius:
            return value
        case .fahrenheight:
            return (value - 32.0) / 1.8
        }
    }

    func fromStandardUnit(_ value: Double) -> Double {
        switch self {
        case .celcius:
            return value
        case .fahrenheight:
            return (value * 1.8) + 32
        }
    }
}

protocol Unitable: CaseIterable {
    static var allUnits: [Unit] { get }
    var unit: Unit { get }
    var rawValue: String { get }
    func toStandardUnit(_ value: Double) -> Double
    func fromStandardUnit(_ value: Double) -> Double
    
}

extension Unitable {
    var unit: Unit { Unit(unit: self) }
    
    static var allUnits: [Unit] {
        allCases.map({ $0.unit })
    }
}

struct Unit: Hashable {
    
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
