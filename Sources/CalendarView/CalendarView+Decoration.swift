//
//  CalendarView+Decoration.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import SwiftUI

extension CalendarView {
    public typealias DecorationSize = UICalendarView.DecorationSize
    
    public struct Decoration: Sendable, Hashable {
        internal let decoration: UICalendarView.Decoration
        
        public init() {
            self.decoration = .init()
        }
        
        private init(_ decoration: UICalendarView.Decoration) {
            self.decoration = decoration
        }
        
        /// Creates a default calendar view decoration with a filled circle image, using the color and size you specify.
        /// - Parameters:
        ///   - color: A color for the decoration.
        ///   - size: A relative size for the decoration.
        /// - Returns: A calendar view decoration.
        public static func `default`(
            color: Color? = nil,
            size: DecorationSize = .medium
        ) -> Decoration {
            .init(
                .default(
                    color: color.map { UIColor($0) },
                    size: size
                )
            )
        }
        
        /// Creates a new calendar view decoration with the image, color, and size that you specify.
        ///
        /// The image defaults to `circlebadge.fill` if you don't specify it.
        ///
        /// The color defaults to [`systemFill`](https://developer.apple.com/documentation/uikit/uicolor/3255070-systemfill) if you don't specify it.
        ///
        /// The size defaults to [`.medium`](https://developer.apple.com/documentation/uikit/uicalendarview/decorationsize/medium) if `nil`.
        /// - Parameters:
        ///   - image: An image to display as the decoration.
        ///   - color: A color for the decoration.
        ///   - size: A relative size for the decoration.
        /// - Returns: A calendar view decoration.
        public static func image(
            _ image: UIImage?,
            color: Color? = nil,
            size: DecorationSize = .medium
        ) -> Decoration {
            .init(
                .image(
                    image,
                    color: color.map { UIColor($0) },
                    size: size
                )
            )
        }
        
        /// Creates a new calendar view decoration with the image, color, and size that you specify.
        ///
        /// The image defaults to `circlebadge.fill` if you don't specify it.
        ///
        /// The color defaults to [`systemFill`](https://developer.apple.com/documentation/uikit/uicolor/3255070-systemfill) if you don't specify it.
        ///
        /// The size defaults to [`.medium`](https://developer.apple.com/documentation/uikit/uicalendarview/decorationsize/medium) if `nil`.
        /// - Parameters:
        ///   - systemName: The name of the system symbol image to display as the decoration.
        ///   - color: A color for the decoration.
        ///   - size: A relative size for the decoration.
        /// - Returns: A calendar view decoration.
        public static func image(
            _ systemName: String,
            color: Color? = nil,
            size: DecorationSize = .medium
        ) -> Decoration {
            .init(
                .image(
                    .init(systemName: systemName),
                    color: color.map { UIColor($0) },
                    size: size
                )
            )
        }
    }
}
