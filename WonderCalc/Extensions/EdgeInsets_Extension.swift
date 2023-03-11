//
//  EdgeInsets_Extension.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 2/15/23.
//

import SwiftUI

extension EdgeInsets {

    static var bottomPad: EdgeInsets {
        EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
    }

    static var none: EdgeInsets {
        EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }

    static var standard: EdgeInsets {
        EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    }

    static var wide: EdgeInsets {
        EdgeInsets(top: 16, leading: 72, bottom: 16, trailing: 72)
    }
}
