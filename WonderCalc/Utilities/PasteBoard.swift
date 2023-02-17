//
//  PasteBoard.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/17/23.
//

import UIKit

protocol PasteBoardable {
    func copy(_ value: String)
    func paste() -> String?
}

struct PasteBoard: PasteBoardable {
    let pasteBoard: UIPasteboard

    func copy(_ value: String) {
        pasteBoard.string = value
    }

    func paste() -> String? {
        return pasteBoard.string
    }

    static let standard: PasteBoard = PasteBoard(pasteBoard: UIPasteboard.general)
}
