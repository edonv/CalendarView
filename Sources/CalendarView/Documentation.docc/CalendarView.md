# ``CalendarView/CalendarView``

## Overview

`CalendarView` is a SwiftUI wrapper of `UICalendarView`, which is a view that displays a calendar that provides for user selection of a single date or multiple dates. It also allows for displaying date-specific decorations. For more info on its full capabilities, see [Apple's documentation](https://developer.apple.com/documentation/uikit/uicalendarview).

Configure the `Calendar`, `Locale`, and `TimeZone` by setting those values in the `Environment` (you can use the provided convenience View modifiers). See additional details about configuration below.

## Basic Usage

The minimum needed to work with `CalendarView` is to attach it to a `Binding` variable with a `DateComponents` type. If you want to limit date selection to a single date at a time, use an optional `DateComponents`. To allow multiple date selection, the `Binding` should be a `Set<DateComponents>`.

> Tip: If you don't need to track any selection, you can also omit this parameter entirely.
>
> And, alternatively, if using multiple selection and the order the selections are made matters, you can use `[DateComponents]` instead of a `Set`.

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

> Warning: When updating the `selection` `Binding` outside of `CalendarView`, be wary.
>
> If you manually create or make changes to a `DateComponents` instance output from `CalendarView` with components that aren't exactly the same as those set internally by the view, you might get unexpected behavior, such as duplicate selections and more.
>
> It's recommended to use the `Binding` as a "read-only" property and not to write to it directly.

## Advanced Configuration

### Environment Values

Some elements of the `CalendarView` can be set with SwiftUI [`Environment`](https://developer.apple.com/documentation/swiftui/environment) and its standard `ViewModifier` ([`environment(_:_:)`](https://developer.apple.com/documentation/swiftui/view/environment(_:_:))).

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

### Decorations

Another feature of `UICalendarView` (and therefore, `CalendarView` by proxy), is to display "decorations" along with any of the dates in the calendar. These can be different for different dates in the calendar, one type of decoration for all dates, or no decorations whatsoever.

The different types of decorations are as follows:
- ``Decoration/default(color:size:)``
    - A decoration with a filled circle image, using the color and size you specify.
- ``Decoration/image(_:color:size:)-93j4e``
    - A decoration with the image, color, and size that you specify.
    - You can specify an image with a `UIImage` or the name of an SF Symbols icon.
    - If you don't specify an image, it defaults to the `circlebadge.fill` symbol.
    - If you don't specify a color, it defaults to [`systemFill`](https://developer.apple.com/documentation/uikit/uicolor/3255070-systemfill).
- ``Decoration/custom(_:)``
    - A custom decoration with a custom SwiftUI view, via a `@ViewBuilder` closure.

> Tip: You can use multiple decoration modifiers to specify different decorations for different dates (or for all dates not explicitly specified in other modifiers).
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

### Font Design

The font design that the calendar view uses for displaying calendar text. `CalendarView` comes with a `ViewModifier` to set this:

```swift
CalendarView($selectedDate)
    .fontDesign(.rounded)
```

### Visible Date Components

Using the ``visibleDateComponents`` parameter in `CalendarView`'s initializer (`Binding<DateComponents?>`), you can control the visible part of in the calendar view. It can also be used to keep track of what part of the calendar is currently be used.

```swift
struct ContentView: View {
    @State
    private var selectedDate: DateComponents? = nil

    // This sets the initial month shown to May 2024
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

> Important: If ``visibleDateComponents``'s [`calendar`](https://developer.apple.com/documentation/foundation/datecomponents/1779873-calendar) property is set to a different `Calendar` than the view's `calendar` (see <doc:#Environment-Values>), the view uses the current `Environment`'s [`calendar`](https://developer.apple.com/documentation/swiftui/environmentvalues/calendar), which may result in an invalid date from the date components.

### Available Date Range

Using the ``availableDateRange`` parameter in `CalendarView`'s initializer (`DateInterval`), you can control the range of dates that the calendar view is able to display. Setting this parameter restricts the earliest or latest dates that the calendar view displays. The default date range is from [`distantPast`](https://developer.apple.com/documentation/foundation/date/1779829-distantpast) to [`distantFuture`](https://developer.apple.com/documentation/foundation/date/1779684-distantfuture).

For convenience, an extra protocol comes with the package: ``DateRangeExpression``, which allows a `DateInterval` to be initialized from a few of the range types. Additionally, it comes with support for using "`Range`-literal" syntax with `Date` values to create a `DateInterval` value. Specifically, it works with the syntax for:
- `ClosedRange`: `date1...date2`
- `PartialRangeFrom`: `date1...`
    - Open upper end of range is set to `distantFuture`.
- `PartialRangeThrough`: `...date2`
    - Open lower end of range is set to `distantPast`.

```swift
CalendarView(
    $selectedDate,
    // This would only allow the user to select
    // a date from the current moment in time onward.
    availableDateRange: Date.now...
)
```

## Topics

### Initializers

- ``init(_:visibleDateComponents:availableDateRange:)-2thw``
- ``init(_:visibleDateComponents:availableDateRange:)-4df2h``
- ``init(_:visibleDateComponents:availableDateRange:)-siyy``

### Environment Configuration

- ``SwiftUI/View/calendar(_:)``
- ``SwiftUI/View/locale(_:)``
- ``SwiftUI/View/timeZone(_:)``

### Decorations

- ``Decoration``
- ``decorations(_:)-8b6f0``
- ``decorations(_:)-6ifm``
- ``decorations(for:_:)-6j91n``
- ``decorations(for:_:)-4bggj``
<!--- ``decorations(for:)``-->
- ``DecorationCallback``
- ``DecorationSize``

### Font Design

- ``fontDesign(_:)``

### Visible Date Components

- ``visibleDateComponents``

### Available Date Range

- ``availableDateRange``

### UIViewRepresentable

- ``makeUIView(context:)``
- ``updateUIView(_:context:)``
- ``makeCoordinator()``
- ``Coordinator``
