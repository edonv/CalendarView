//
//  CalendarView+SelectionMode.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import Foundation

extension CalendarView {
    internal struct SelectionMode: Sendable, Hashable, RawRepresentable {
        var rawValue: UInt8
        init?(rawValue: UInt8) {
            guard SelectionMode.isValidValue(rawValue) else { return nil }
            self.rawValue = rawValue
        }
        
        private static func isValidValue(_ rawValue: UInt8) -> Bool {
            if [1, 0b10].contains(rawValue) {
                return true
            } else if rawValue == 0b100,
                      #available(iOS 18.0, macCatalyst 18.0, visionOS 2.0, *) {
                return true
            } else {
                return false
            }
        }
        
        internal static let singleDate = SelectionMode(rawValue: 1 << 0)!
        internal static let multiDate = SelectionMode(rawValue: 1 << 1)!
        
        @available(iOS 18.0, macCatalyst 18.0, visionOS 2.0, *)
        internal static let weekOfYear = SelectionMode(rawValue: 1 << 2)!
    }
}
