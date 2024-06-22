//
//  EnvironmentModifiers.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import SwiftUI

extension View {
    /// Sets the current calendar that views should use when handling dates.
    /// - Parameter calendar: A new Calendar.
    public func calendar(_ calendar: Calendar) -> some View {
        self.environment(\.calendar, calendar)
    }
    
    /// Sets the current locale that views should use.
    /// - Parameter calendar: A new Locale.
    public func locale(_ locale: Locale) -> some View {
        self.environment(\.locale, locale)
    }
    
    /// Sets the current time zone that views should use when handling dates.
    /// - Parameter calendar: A new TimeZone.
    public func timeZone(_ timeZone: TimeZone) -> some View {
        self.environment(\.timeZone, timeZone)
    }
}
