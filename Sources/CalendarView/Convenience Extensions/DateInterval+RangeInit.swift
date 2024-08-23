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
    /// Converts a date range expression to a `DateInterval`.
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

extension Date {
    /// Returns a `DateInterval` using `ClosedRange` syntax.
    /// - Parameters:
    ///   - minimum: The lower bound for the interval.
    ///   - maximum: The upper bound for the interval.
    public static func ... (minimum: Self, maximum: Self) -> DateInterval {
        .init(minimum...maximum)
    }
    
    /// Returns a `DateInterval` using `PartialRangeFrom` syntax.
    /// - Parameters:
    ///   - minimum: The lower bound for the interval.
    public static postfix func ... (minimum: Self) -> DateInterval {
        .init(minimum...)
    }
    
    /// Returns a `DateInterval` using `PartialRangeThrough` syntax.
    /// - Parameters:
    ///   - maximum: The upper bound for the interval.
    public static prefix func ... (maximum: Self) -> DateInterval {
        .init(...maximum)
    }
}
