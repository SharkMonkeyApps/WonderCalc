//
//  UnitConversionTests.swift
//  WonderCalcTests
//
//  Created by Steven Schwedt on 2/11/23.
//

import XCTest
@testable import WonderCalc

final class UnitConversionTests: XCTestCase {
    
    var unitProvider: UnitProvider!
    
    override func setUp() {
        unitProvider = UnitProvider()
    }
    
    func test_itCanConvertLength() {
        unitProvider.category = .length
        unitProvider.fromValue = "7"
        unitProvider.fromUnit = LengthUnit.feet.unit
        unitProvider.toUnit = LengthUnit.meters.unit
        
        XCTAssertEqual(unitProvider.resultString, "2.1336 meters") // round?
        
        unitProvider.fromValue = "563223.6"
        unitProvider.fromUnit = LengthUnit.centimeters.unit
        unitProvider.toUnit = LengthUnit.miles.unit
        
        XCTAssertEqual(unitProvider.resultString, "3.4997 miles") // round?
    }
    
    func test_itCanConvertTemperature() {
        unitProvider.category = .temperature
        unitProvider.fromValue = "7"
        unitProvider.fromUnit = TemperatureUnit.fahrenheight.unit
        unitProvider.toUnit = TemperatureUnit.celcius.unit
        
        XCTAssertEqual(unitProvider.resultString, "-13.8889 ℃") // round?
        
        unitProvider.fromValue = "435.5"
        unitProvider.fromUnit = TemperatureUnit.celcius.unit
        unitProvider.toUnit = TemperatureUnit.kelvin.unit
        
        XCTAssertEqual(unitProvider.resultString, "708.65 Kelvin")
    }
    
    func test_itCanConvertVolume() {
        unitProvider.category = .volume
        unitProvider.fromValue = "7"
        unitProvider.fromUnit = VolumeUnit.liters.unit
        unitProvider.toUnit = VolumeUnit.gallons.unit
        
        XCTAssertEqual(unitProvider.resultString, "1.8492 gallons")
        
        unitProvider.fromValue = "435.5"
        unitProvider.fromUnit = VolumeUnit.teaspoon.unit
        unitProvider.toUnit = VolumeUnit.milliliters.unit
        
        XCTAssertEqual(unitProvider.resultString, "2146.5443 milliliters")
    }

    func test_itCanConvertWeight() {
        unitProvider.category = .weight
        unitProvider.fromValue = "7"
        unitProvider.fromUnit = WeightUnit.kilograms.unit
        unitProvider.toUnit = WeightUnit.ounces.unit

        XCTAssertEqual(unitProvider.resultString, "246.9179 ounces")

        unitProvider.fromValue = "435.5"
        unitProvider.fromUnit = WeightUnit.grams.unit
        unitProvider.toUnit = WeightUnit.pounds.unit

        XCTAssertEqual(unitProvider.resultString, "0.9601 pounds")
    }
}

// MARK: - Helpers

extension UnitProvider {
    /** Convienience accessor for testing */
    var resultString: String { "\(result.value) \(result.unit)" }
}
