//
//  UnitConversionTests.swift
//  WonderCalcTests
//
//  Created by Steven Schwedt on 2/11/23.
//

import XCTest
@testable import WonderCalc

final class UnitTests: XCTestCase {
    
    var unitProvider: UnitProvider!
    
    override func setUp() {
        unitProvider = UnitProvider()
    }
    
    func test_itCanConvertLength() {
        unitProvider.category = .length
        unitProvider.fromValue = "7"
        unitProvider.fromUnit = LengthUnit.feet.unit
        unitProvider.toUnit = LengthUnit.meters.unit
        
        XCTAssertEqual(unitProvider.result, "2.133599931724802 meters") // round?
        
        unitProvider.fromValue = "563223.6"
        unitProvider.fromUnit = LengthUnit.centimeters.unit
        unitProvider.toUnit = LengthUnit.miles.unit
        
        XCTAssertEqual(unitProvider.result, "3.4997093102727272 miles") // round?
    }
    
    func test_itCanConvertTemperature() {
        unitProvider.category = .temperature
        unitProvider.fromValue = "7"
        unitProvider.fromUnit = TemperatureUnit.fahrenheight.unit
        unitProvider.toUnit = TemperatureUnit.celcius.unit
        
        XCTAssertEqual(unitProvider.result, "-13.88888888888889 celcius") // round?
        
        unitProvider.fromValue = "435.5"
        unitProvider.fromUnit = TemperatureUnit.celcius.unit
        unitProvider.toUnit = TemperatureUnit.kelvin.unit
        
        XCTAssertEqual(unitProvider.result, "708.65 kelvin")
    }
    
    func test_itCanConvertVolume() {
        unitProvider.category = .volume
        unitProvider.fromValue = "7"
        unitProvider.fromUnit = VolumeUnit.liters.unit
        unitProvider.toUnit = VolumeUnit.gallons.unit
        
        XCTAssertEqual(unitProvider.result, "1.8492052380059225 gallons")
        
        unitProvider.fromValue = "435.5"
        unitProvider.fromUnit = VolumeUnit.teaspoon.unit
        unitProvider.toUnit = VolumeUnit.milliliters.unit
        
        XCTAssertEqual(unitProvider.result, "2146.544342447917 milliliters")
    }
}
