# CalendarView

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fedonv%2FCalendarView%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/edonv/CalendarView)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fedonv%2FCalendarView%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/edonv/CalendarView)

`CalendarView` is a SwiftUI wrapper of `UICalendarView`, which is a view that displays a calendar that provides for user selection of a single date or multiple dates. It also allows for displaying date-specific decorations.

More info on its full capabilities can be found at Apple's documentation for `UICalendarView`.

## Basic Usage

The minimum needed to work with `CalendarView` is to attach it to a `Binding` variable with a `DateComponents` type. If you want to limit date selection to a single date at a time, use a `DateComponents?` (an optional `DateComponents`). To allow multiple date selection, the `Binding` should be a `Set<DateComponents>` (a `Set` of `DateComponents`).

> [!TIP]
> If you don't need to track any selection, you can also omit this parameter entirely.
>
> And, alternatively, if using multiple selection and the order the selections are made matters, you can use an `[DateComponents]` instead of a `Set`.

```swift
struct ContentView: View {
    @State
    private var singleDateSelection: DateComponents? = nil

    @State
    private var multipleDateSelection: Set<DateComponents> = []

    var body: some View {
        VStack {
            CalendarView($singleDateSelection)

            CalendarView($multipleDateSelection)
        }
    }
}
```

> [!WARNING]
> When updating the `selection` `Binding` outside of `CalendarView`, be wary.
>
> If you manually create or make changes to a `DateComponents` instance output from `CalendarView` with components that aren't exactly the same as those set internally by the view, you might get unexpected behavior, such as duplicate selections and more.
>
> It's recommended to use the `Binding` as a "read-only" property and not to write to it directly.

## Advanced Configuration

### Environment Values

Some elements of the `CalendarView` can be set with the standard SwiftUI [`Environment`](https://developer.apple.com/documentation/swiftui/environment) and its standard `ViewModifier` ([`.environment(_:_:)`](https://developer.apple.com/documentation/swiftui/view/environment(_:_:))).

This also means that `CalendarView` also reacts to these settings if they're set in the parent `Environment`. And for convenience, the package comes with abbreviated modifiers to directly set these values.

These elements are:

- The actual calendar system ([`\.calendar`](https://developer.apple.com/documentation/swiftui/environmentvalues/calendar)/[`Calendar`](https://developer.apple.com/documentation/foundation/calendar))
    - i.e. Gregorian vs. Chinese vs. Buddhist
- The language ([`\.locale`](https://developer.apple.com/documentation/swiftui/environmentvalues/locale)/[`Locale`](https://developer.apple.com/documentation/foundation/locale))
- The time zone ([`\.timeZone`](https://developer.apple.com/documentation/swiftui/environmentvalues/timezone)/[`TimeZone`](https://developer.apple.com/documentation/foundation/timezone))
    - Changing this won't have a visual effect, but the selected `DateComponent` values it outputs will have the applied `TimeZone` (or the one in the active `Environment`) pre-set.

```swift
CalendarView($selectedDate)
    // Environment Modifier
    // Calendar
    .environment(\.calendar, Calendar(identifier: .chinese))
    // Locale
    .environment(\.locale, Locale(identifier: "en_GB"))
    // Time Zone
    .environment(\.timeZone, TimeZone(identifier: "America/Chicago")!)

    // Convenience Modifiers
    // Calendar
    .calendar(Calendar(identifier: .chinese))
    // Locale
    .locale(Locale(identifier: "en_GB"))
    // Time Zone
    .timeZone(TimeZone(identifier: "America/Chicago")!)
```

### More Configuration

#### Decorations

Another feature of `UICalendarView` (and therefore, `CalendarView` by proxy), is to display "decorations" along with any of the dates in the calendar. These can be different for different dates in the calendar, one type of decoration for all dates, or no decorations whatsoever.

The different types of decorations are as follows:
- `.default(color: Color? = nil, size: DecorationSize = .medium)`
    - A decoration with a filled circle image, using the color and size you specify.
- `.image(_ systemName: String, color: Color? = nil, size: DecorationSize = .medium)`
    - A decoration with the image, color, and size that you specify.
    - You can specify an image with a `UIImage` or the name of an SF Symbols icon.
    - If you don't specify an image, it defaults to the `circlebadge.fill` symbol.
    - If you don't specify a color, it defaults to [`.systemFill`](https://developer.apple.com/documentation/uikit/uicolor/3255070-systemfill).
- `.custom(@ViewBuilder _ customViewProvider: () -> some View)`
    - A custom decoration with a custom SwiftUI view, via a `@ViewBuilder` closure.

- `.image(_:color:size:)`

> [!TIP]
> You can use multiple decoration modifiers to specify different decorations for different dates (or for all dates not explicitly specified in other modifiers).
>
> A decoration for a explicitly specified for a particular date takes precedence over a decoration specified for no specific date.

<!--
This isn't working as intended
// This adds the default decoration only under the date May 14 2024
// (assuming the calendar is set to .gregorian)
.decorations(for: DateComponents(year: 2024, month: 5, day: 14), .default()) 
-->

```swift
CalendarView($selectedDate)
    // This sets an orange `star.fill` symbol under all dates in the calendar.
    .decorations(.image("star.fill", color: .orange))
    // This displays the month number under each date (why not?) using a SwiftUI ViewBuilder
    .decorations { dateComponents in
        Text(dateComponents.month ?? 0, format: .number)
    }
```

#### Font Design

The font design that the calendar view uses for displaying calendar text. `CalendarView` comes with a `ViewModifier` to set this.

```swift
CalendarView($selectedDate)
    .fontDesign(.rounded)
```

#### Visible Date Components

Using the `visibleDateComponents` parameter in `CalendarView`'s initializer (`Binding<DateComponents?>`), you can control the visible part of in the calendar view. It can also be used to keep track of what part of the calendar is currently be used.

> [!IMPORTANT]
> If `visibleDateComponents.calendar` is set to a different `Calendar` than the view's `calendar` (see [Environment Values](#environment-values)), the view uses the current `Environment`'s `calendar`, which may result in an invalid date from the date components.

```swift
struct ContentView: View {
    @State
    private var selectedDate: DateComponents? = nil

    @State
    private var currentlyViewedComponents: DateComponents? = .init(
        calendar: calendar,
        year: 2024,
        month: 5
    )

    var body: some View {
        CalendarView(
            $selectedDate,
            visibleDateComponents: $currentlyViewedComponents
        )
    }
}
```

#### Available Date Range

Using the `availableDateRange` parameter in `CalendarView`'s initializer (`DateInterval`), you can control the range of dates that the calendar view is able to display. Setting this parameter restricts the earliest or latest dates that the calendar view displays. The default date range is from `distantPast` to `distantFuture`.

For convenience, an extra protocol comes with the package: `DateRangeExpression`, which allows a `DateInterval` to be initialized from a few of the range types. Additionally, it comes with support for using "`Range`-literal" syntax with `Date` values to create a `DateInterval` value. Specifically, it works with the syntax for:
- `ClosedRange`: `date1...date2`
- `PartialRangeFrom`: `date1...`
    - Open upper end of range is set to `.distantFuture`.
- `PartialRangeThrough`: `...date2`
    - Open lower end of range is set to `.distantPast`.

```swift
CalendarView(
    $selectedDate,
    // This would only allow the user to select a date after the current moment in time.
    availableDateRange: Date.now...
)
```
