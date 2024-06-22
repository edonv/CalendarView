//
//  CalendarView.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import SwiftUI

/// A view that displays a calendar with date-specific decorations, and provides for user selection of a single date or multiple dates.
///
/// Configure the Calendar, Locale, and TimeZone by setting those values in the `Environment` (you can use the provided convenience View modifiers).
public struct CalendarView: UIViewRepresentable {
    /// The date components that represent the visible date in the calendar view.
    ///
    /// If `visibleDateComponents.calendar` is `nil` or isn't equal to [`calendar`](https://developer.apple.com/documentation/swiftui/environmentvalues/calendar), the view uses [`calendar`](https://developer.apple.com/documentation/swiftui/environmentvalues/calendar), which may result in an invalid date from the date components.
    public let visibleDateComponents: DateComponents?
    
    /// The range of dates that the calendar view displays.
    ///
    /// Set `availableDateRange` to restrict the earliest or latest dates that the calendar view displays. The default date range starts with [`distantPast`](https://developer.apple.com/documentation/foundation/date/1779829-distantpast) and ends with [`distantFuture`](https://developer.apple.com/documentation/foundation/date/1779684-distantfuture).
    public let availableDateRange: DateInterval?
    
    public init(
        visibleDateComponents: DateComponents? = nil,
        availableDateRange: DateInterval? = nil
    ) {
        self.visibleDateComponents = visibleDateComponents
        self.availableDateRange = availableDateRange
    }
    
    public func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView(frame: .zero)
        
        if let visibleDateComponents {
            view.visibleDateComponents = visibleDateComponents
        }
        
        if let availableDateRange {
            view.availableDateRange = availableDateRange
        }
        
        view.fontDesign = self.fontDesign
        
        view.calendar = context.environment.calendar
        view.locale = context.environment.locale
        view.timeZone = context.environment.timeZone
        
        return view
    }
    
    public func updateUIView(_ uiView: UICalendarView, context: Context) {
                
    
    // MARK: - Misc Modifier Properties
    
    private var fontDesign: UIFontDescriptor.SystemDesign = .default
    
    /// A font design that the calendar view uses for displaying calendar text.
    ///
    /// Defaults to [`default`](https://developer.apple.com/documentation/uikit/uifontdescriptor/systemdesign/3151799-default).
    public func fontDesign(_ design: UIFontDescriptor.SystemDesign) -> CalendarView {
        var new = self
        new.fontDesign = design
        return new
    }
    }
}
