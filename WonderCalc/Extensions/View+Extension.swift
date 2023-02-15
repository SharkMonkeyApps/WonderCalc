//
//  View+Extension.swift
//  WonderCalc
//
//  Created by Steven Schwedt on 11/19/22.
//

import SwiftUI

public extension View {
    /** Calls a view modifier that will dismiss a keyboard if the users taps elsewhere */
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

/** A view modifier that will dismiss a keyboard if the users taps elsewhere */
public struct DismissKeyboardOnTap: ViewModifier {
    public func body(content: Content) -> some View {
        #if os(macOS)
        return content
        #else
        return content.gesture(tapGesture)
        #endif
    }

    private var tapGesture: some Gesture {
        TapGesture().onEnded(endEditing)
    }

    private func endEditing() {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .map {$0 as? UIWindowScene}
            .compactMap({$0})
            .first?.windows
            .filter {$0.isKeyWindow}
            .first?.endEditing(true)
    }
}
