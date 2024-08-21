# CalendarView

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fedonv%2FCalendarView%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/edonv/CalendarView)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fedonv%2FCalendarView%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/edonv/CalendarView)

A SwiftUI wrapper of [`UICalendarView`](https://developer.apple.com/documentation/uikit/uicalendarview).


## How to Use [`CalendarView`](./Sources/CalendarView/CalendarView.swift)

[`CalendarView`](./Sources/CalendarView/CalendarView.swift) is a SwiftUI view that displays a calendar with date-specific decorations and allows for user selection of a single date or multiple dates. Below are the steps to integrate and use [`CalendarView`](./Sources/CalendarView/CalendarView.swift) in your SwiftUI project.

## 1. Import the Required Module
Ensure you import SwiftUI in your Swift file:

```Swift
import SwiftUI
```

## 2. Configure the CalendarView
You can configure the [`CalendarView`](./Sources/CalendarView/CalendarView.swift) by setting the necessary properties and environment values.

**Example Usage:**

```Swift
import SwiftUI

struct ContentView: View {
    @State private var selectedDate: DateComponents? = nil

    var body: some View {
        CalendarView(visibleDateComponents: $selectedDate)
            .environment(\.calendar, Calendar.current)
            .environment(\.locale, Locale.current)
            .environment(\.timeZone, TimeZone.current)
    }
}
```

## 3. Environment Configuration

You can configure the calendar, locale, and time zone by setting those values in the [`Environment`](https://developer.apple.com/documentation/swiftui/environment). Use the provided convenience view modifiers to set these values.

```Swift
CalendarView(visibleDateComponents: $selectedDate)
    .environment(\.calendar, Calendar(identifier: .gregorian))
    .environment(\.locale, Locale(identifier: "en_US"))
    .environment(\.timeZone, TimeZone(abbreviation: "PST")!)
```

## 4. Handling Date Selection

The [`CalendarView`](./Sources/CalendarView/CalendarView.swift) uses a [`Binding<DateComponents?>`](./Sources/CalendarView/CalendarView.swift) to handle the selected date. Ensure you manage this binding appropriately in your view.

```Swift
@State private var selectedDate: DateComponents? = nil

var body: some View {
    CalendarView(visibleDateComponents: $selectedDate)
}
```

## 5. Date Range Configuration

You can restrict the range of dates that the calendar view displays by setting the [`availableDateRange`](./Sources/CalendarView/CalendarView.swift).

```Swift
CalendarView(visibleDateComponents: $selectedDate)
    .availableDateRange(Date.distantPast...Date.distantFuture)
```

### Important Notes

When updating the [`selection`](./Sources/CalendarView/CalendarView.swift) Binding outside of [`CalendarView`](./Sources/CalendarView/CalendarView.swift), be cautious. If you create a [`DateComponents`](./Sources/CalendarView/CalendarView.swift) instance with components that aren't exactly the same as those set internally by [`CalendarView`](./Sources/CalendarView/CalendarView.swift), you might encounter unexpected behaviour, such as duplicate selections.

For more detailed information, refer to the [`UICalendarView`](https://developer.apple.com/documentation/uikit/uicalendarview/) documentation.
