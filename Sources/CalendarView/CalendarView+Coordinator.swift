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
        
        internal init(_ parent: CalendarView) {
            self.parent = parent
            super.init()
        }
    }
}
