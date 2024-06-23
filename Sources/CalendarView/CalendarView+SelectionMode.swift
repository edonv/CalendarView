//
//  CalendarView+SelectionMode.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import Foundation

extension CalendarView {
    /// Not an enum because there will be a new case added that is only available on specific OS versions.
    internal struct SelectionMode: Sendable, Hashable {
        private var rawValue: UInt8
        private init?(rawValue: UInt8) {
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
        
        // TODO: implement new option on updated Xcode
//        @available(iOS 18.0, macCatalyst 18.0, visionOS 2.0, *)
//        internal static let weekOfYear = SelectionMode(rawValue: 1 << 2)!
    }
}
