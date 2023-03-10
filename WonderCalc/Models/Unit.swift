//
//  Unit.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/16/22.
//

import Foundation
import Combine

/** Calculates and publishes values for unit conversion */
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
