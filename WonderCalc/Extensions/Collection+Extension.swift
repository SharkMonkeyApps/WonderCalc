//
//  Collection+Extension.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/14/23.
//

import Foundation

extension Collection {
    /** Returns the element at the specified index if it is within bounds, otherwise nil. */
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    /** Mutating function that removes an element at a specified index if it exists. */
    mutating func remove(safe index: Index) -> Element? {
        return indices.contains(index) ? remove(at: index) : nil
    }
}
