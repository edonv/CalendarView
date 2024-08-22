//
//  CalendarView.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import SwiftUI

/// A view that displays a calendar with date-specific decorations, and provides for user selection of a single date or multiple dates.
///
/// Configure the `Calendar`, `Locale`, and `TimeZone` by setting those values in the `Environment` (you can use the provided convenience View modifiers).
///
/// See [`UICalendarView`](https://developer.apple.com/documentation/uikit/uicalendarview) for more info.
///
/// > Important: When updating the `selection` `Binding` outside of `CalendarView`, be wary.
/// >
/// > If you manually create or make changes to a `DateComponents` instance output from `CalendarView` with components that aren't exactly the same as those set internally by the view, you might get unexpected behavior, such as duplicate selections and more.
/// >
/// > It's recommended to use the `Binding` as a "read-only" property and not to write to it directly.
public struct CalendarView: UIViewRepresentable {
    /// The date components that represent the visible date in the calendar view.
    ///
    /// This essentially describes the visible view of the calendar.
    ///
    /// If `visibleDateComponents.calendar` is `nil` or isn't equal to [`calendar`](https://developer.apple.com/documentation/swiftui/environmentvalues/calendar), the view uses [`calendar`](https://developer.apple.com/documentation/swiftui/environmentvalues/calendar), which may result in an invalid date from the date components.
    public let visibleDateComponents: Binding<DateComponents?>
    
    /// The range of dates that the calendar view displays.
    ///
    /// Set `availableDateRange` to restrict the earliest or latest dates that the calendar view displays. The default date range starts with [`distantPast`](https://developer.apple.com/documentation/foundation/date/1779829-distantpast) and ends with [`distantFuture`](https://developer.apple.com/documentation/foundation/date/1779684-distantfuture).
    public let availableDateRange: DateInterval?
    
    @Binding
    internal var selection: [DateComponents]
    internal let selectionMode: SelectionMode?
    
    /// Creates a calendar view with ordered, multiple selection.
    /// - Parameters:
    ///   - selection: A binding to an array that identifies selected dates.
    ///   - visibleDateComponents: The date components that represent the visible date in the calendar view. This essentially describes the visible view of the calendar. Leave `nil` for default value, which is the current month.
    ///   - availableDateRange: The range of dates that the calendar view displays and allows for selection. Leave `nil` for no limit.
    public init(
        _ selection: Binding<[DateComponents]>,
        visibleDateComponents: Binding<DateComponents?>? = nil,
        availableDateRange: DateInterval? = nil
    ) {
        self._selection = selection
        self.selectionMode = .multiDate
        self.visibleDateComponents = visibleDateComponents ?? .constant(nil)
        self.availableDateRange = availableDateRange
    }
    
    /// Creates a calendar view with unordered, multiple selection.
    /// - Parameters:
    ///   - selection: A binding to an unordered set that identifies selected dates.
    ///   - visibleDateComponents: The date components that represent the visible date in the calendar view. This essentially describes the visible view of the calendar. Leave `nil` for default value, which is the current month.
    ///   - availableDateRange: The range of dates that the calendar view displays and allows for selection. Leave `nil` for no limit.
    public init(
        _ selection: Binding<Set<DateComponents>>,
        visibleDateComponents: Binding<DateComponents?>? = nil,
        availableDateRange: DateInterval? = nil
    ) {
        self.init(
            selection.map { set in
                Array(set)
            } reverse: { arr in
                Set(arr)
            },
            visibleDateComponents: visibleDateComponents,
            availableDateRange: availableDateRange
        )
    }
    
    /// Creates a calendar view, optionally with single selection.
    /// - Parameters:
    ///   - selection: A binding to a selected date.
    ///   - visibleDateComponents: The date components that represent the visible date in the calendar view. This essentially describes the visible view of the calendar. Leave `nil` for default value, which is the current month.
    ///   - availableDateRange: The range of dates that the calendar view displays and allows for selection. Leave `nil` for no limit.
    public init(
        _ selection: Binding<DateComponents?>? = nil,
        visibleDateComponents: Binding<DateComponents?>? = nil,
        availableDateRange: DateInterval? = nil
    ) {
        if let selection {
            self._selection = selection.map { value in
                value.map { [$0] } ?? []
            } reverse: { arr in
                arr.first
            }
            self.selectionMode = .singleDate
        } else {
            self._selection = .constant([])
            self.selectionMode = nil
        }
        self.visibleDateComponents = visibleDateComponents ?? .constant(nil)
        self.availableDateRange = availableDateRange
    }
    
    public func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView(frame: .zero)
        
        if let selectionMode = self.selectionMode {
            switch selectionMode {
            case .singleDate:
                view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
            case .multiDate:
                view.selectionBehavior = UICalendarSelectionMultiDate(delegate: context.coordinator)
            default:
                view.selectionBehavior = nil
            }
        } else {
            view.selectionBehavior = nil
        }
        
        if let availableDateRange {
            view.availableDateRange = availableDateRange
        }
        
        view.fontDesign = self.fontDesign
        view.wantsDateDecorations = self.decorationCallback != nil
        view.delegate = context.coordinator
        
        return view
    }
    
    public func updateUIView(_ uiView: UICalendarView, context: Context) {
        context.coordinator.isUpdatingView = true
        defer { context.coordinator.isUpdatingView = false }
        
        // Update environment values
        uiView.calendar = context.environment.calendar
        uiView.locale = context.environment.locale
        uiView.timeZone = context.environment.timeZone
        
        let shouldAnimate = context.transaction.animation != nil
        
        // Update selections
        if let selectionObj = uiView.selectionBehavior {
            // Make sure Binding has no duplicates and no values outside the validRange
            var filtered = self.selection
                .removingDuplicates()
            
            // Filter out any values that aren't in the range
            if let availableDateRange = self.availableDateRange {
                filtered.removeAll { components in
                    guard let date = uiView.calendar.date(from: components) else { return false }
                    return !availableDateRange.contains(date)
                }
            }
            
            if self.selectionMode == .singleDate,
               let singleDate = selectionObj as? UICalendarSelectionSingleDate,
               singleDate.selectedDate != filtered.first {
                singleDate.setSelected(
                    filtered.first,
                    animated: shouldAnimate
                )
            } else if self.selectionMode == .multiDate,
                      let multiDate = selectionObj as? UICalendarSelectionMultiDate,
                      multiDate.selectedDates != filtered {
                
                multiDate.setSelectedDates(
                    filtered,
                    animated: shouldAnimate
                )
            }
            
            if filtered != self.selection {
                self.selection = filtered
            }
        }
        
        // Update visible components
        if let visibleDateComponents = self.visibleDateComponents.wrappedValue,
           uiView.visibleDateComponents != visibleDateComponents {
            uiView.setVisibleDateComponents(
                visibleDateComponents,
                animated: shouldAnimate
            )
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Misc Modifier Properties
    
    private var fontDesign: UIFontDescriptor.SystemDesign = .default
    
    /// A font design that the calendar view uses for displaying calendar text.
    ///
    /// Defaults to [`.default`](https://developer.apple.com/documentation/uikit/uifontdescriptor/systemdesign/3151799-default).
    public func fontDesign(_ design: UIFontDescriptor.SystemDesign) -> CalendarView {
        var new = self
        new.fontDesign = design
        return new
    }
    
    /// A font design that the calendar view uses for displaying calendar text.
    ///
    /// Defaults to [`.default`](https://developer.apple.com/documentation/swiftui/font/design/default).
    public func fontDesign(_ design: Font.Design) -> CalendarView {
        let design: UIFontDescriptor.SystemDesign = switch design {
        case .default: .default
        case .serif: .serif
        case .rounded: .rounded
        case .monospaced: .monospaced
        @unknown default: .default
        }
        
        return self.fontDesign(design)
    }
    
    public typealias DecorationCallback = (_ dateComponents: DateComponents) -> Decoration?
    internal var decorationCallback: DecorationCallback? = nil
    internal var dateSpecificDecorations: [DateComponents: Decoration] = [:]
    
    /// Set decoration views for dates in the CalendarView.
    public func decorations(_ callback: DecorationCallback? = nil) -> CalendarView {
        var new = self
        new.decorationCallback = callback
        return new
    }
    
    /// Set custom decoration views for dates in the CalendarView view a `@ViewBuilder`.
    public func decorations(@ViewBuilder _ customViewProvider: @escaping (_ dateComponents: DateComponents) -> some View) -> CalendarView {
        var new = self
        new.decorationCallback = { dateComponents in
            return .custom {
                customViewProvider(dateComponents)
            }
        }
        return new
    }
    
    /// Set decoration views for specific dates in the CalendarView.
    public func decorations<C>(
        for dates: C,
        _ decoration: Decoration?
    ) -> CalendarView where C: Collection, C.Element == DateComponents {
        var new = self
        if let decoration {
            new.dateSpecificDecorations.merge(
                dates.reduce(into: [:]) { $0[$1] = decoration },
                uniquingKeysWith: { (_, new) in new }
            )
        } else {
            for key in dates {
                new.dateSpecificDecorations.removeValue(forKey: key)
            }
        }
        return new
    }
    
    /// Set decoration views for a specific date in the CalendarView.
    public func decorations(for date: DateComponents, _ decoration: Decoration?) -> CalendarView {
        self.decorations(for: CollectionOfOne(date), decoration)
    }
}
