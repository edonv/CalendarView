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
        
        internal var isUpdatingView: Bool = false
        
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
        if #unavailable(iOS 16.2, macCatalyst 16.2, visionOS 1.0) {
            // UICalendarView doesn't provide a way to get notified when property visibleDateComponents changes.
            // However, this delegate method is called whenever the user scrolls the view, which in turn
            // allows us to read the current value of visibleDateComponents and update the binding.
            if !isUpdatingView,
                let bound = parent.visibleDateComponents.wrappedValue {
                let visibleComponents = calendarView.visibleDateComponents
                
                if bound.year != visibleComponents.year
                    && bound.month != visibleComponents.month {
                    self.calendarView(calendarView, didChangeVisibleDateComponentsFrom: visibleComponents)
                }
            }
        }
        
        let newComponents: DateComponents
        if let date = calendarView.calendar.date(from: dateComponents) {
            newComponents = calendarView.calendar
                .dateComponents(Self.components, from: date)
        } else {
            newComponents = dateComponents
        }
        
        if let decoration = parent.dateSpecificDecorations[dateComponents] {
            return decoration.decoration
        } else {
            return parent.decorationCallback?(newComponents)?.decoration
        }
    }
    
    public func calendarView(
        _ calendarView: UICalendarView,
        didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents
    ) {
        parent.visibleDateComponents.wrappedValue = calendarView.visibleDateComponents
    }
}

// MARK: - UICalendarSelectionMultiDateDelegate

extension CalendarView.Coordinator: UICalendarSelectionMultiDateDelegate {
    // MARK: Getting selectable dates
    
    // MARK: Changing selected dates
    
    /// Informs the delegate that a user selected a date represented by date components.
    /// - Parameters:
    ///   - selection: An object that tracks one or more dates that a user selects from a calendar view.
    ///   - dateComponents: Date components that represent a date the user selected.
    public func multiDateSelection(
        _ selection: UICalendarSelectionMultiDate,
        didSelectDate dateComponents: DateComponents
    ) {
        guard self.parent.selectionMode == .multiDate else { return }
        self.parent.selection.append(dateComponents)
    }
    
    /// Informs the delegate that a user deselected a date represented by date components.
    /// - Parameters:
    ///   - selection: An object that tracks multiple dates that a user selects from a calendar view.
    ///   - dateComponents: Date components that represent a date the user deselected.
    public func multiDateSelection(
        _ selection: UICalendarSelectionMultiDate,
        didDeselectDate dateComponents: DateComponents
    ) {
        guard self.parent.selectionMode == .multiDate,
              let index = self.parent.selection.firstIndex(of: dateComponents) else { return }
        self.parent.selection.remove(at: index)
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate

extension CalendarView.Coordinator: UICalendarSelectionSingleDateDelegate {
    // MARK: Getting selectable dates
    
    // MARK: Changing the selected date
    
    /// Informs the delegate that a user selected a date represented by date components.
    /// - Parameters:
    ///   - selection: An object that tracks a date that a user selects from a calendar view.
    ///   - dateComponents: Date components that represent a date the user selected, or `nil` if the user deselected a date.
    public func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        guard self.parent.selectionMode == .singleDate else { return }
        self.parent.selection = dateComponents
            .map { [$0] } ?? []
    }
}
