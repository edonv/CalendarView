//
//  DateInterval+RangeInit.swift
//
//
//  Created by Edon Valdman on 6/23/24.
//

import Foundation

extension DateInterval {
    /// Create a `DateInterval` directly from a `Date` range.
    public init<R: DateRangeExpression>(_ range: R) {
        self = range.toInterval()
    }
}

/// A `RangeExpression` type  that is convertible to a `DateInterval`.
///
/// Conforming types are `ClosedRange` (`x...y`), `PartialRangeFrom` (`x...`), and `PartialRangeThrough` (`...y`).
public protocol DateRangeExpression: RangeExpression where Bound == Date {
    func toInterval() -> DateInterval
}

extension ClosedRange<Date>: DateRangeExpression {
    public func toInterval() -> DateInterval {
        .init(start: self.lowerBound, end: self.upperBound)
    }
}

extension PartialRangeFrom<Date>: DateRangeExpression {
    public func toInterval() -> DateInterval {
        .init(start: self.lowerBound, end: .distantFuture)
    }
}

extension PartialRangeThrough<Date>: DateRangeExpression {
    public func toInterval() -> DateInterval {
        .init(start: .distantPast, end: self.upperBound)
    }
}
