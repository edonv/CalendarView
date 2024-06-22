//
//  CalendarView+Coordinator.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import SwiftUI

extension CalendarView {
    public class Coordinator: NSObject {
        private let parent: CalendarView
        
        internal init(_ parent: CalendarView) {
            self.parent = parent
            super.init()
        }
    }
}

// MARK: UICalendarViewDelegate

extension CalendarView.Coordinator: UICalendarViewDelegate {
    private static let components: Set<Calendar.Component> = {
        var temp: Set<Calendar.Component> = [.year, .day, .month, .era, .calendar, .timeZone, .weekOfMonth, .weekOfYear, .weekday, .weekdayOrdinal, .yearForWeekOfYear]
        
        return temp
    }()
    
    public func calendarView(
        _ calendarView: UICalendarView,
        decorationFor dateComponents: DateComponents
    ) -> UICalendarView.Decoration? {
        let newComponents: DateComponents
        if let date = calendarView.calendar.date(from: dateComponents) {
            newComponents = calendarView.calendar
                .dateComponents(Self.components, from: date)
        } else {
            newComponents = dateComponents
        }
        
        return parent.decorationCallback?(newComponents)?.decoration
    }
}
