# ``CalendarView/CalendarView``

## Overview

`CalendarView` is a SwiftUI wrapper of `UICalendarView`, which is a view that displays a calendar that provides for user selection of a single date or multiple dates. It also allows for displaying date-specific decorations.

`CalendarView` can be configured using its `Environment` and a variety of view modifiers.

For more info on how to use `CalendarView`, see <doc:CalendarView+HowTo>

For more info on its full capabilities, see [Apple's documentation](https://developer.apple.com/documentation/uikit/uicalendarview).

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
