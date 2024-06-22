//
//  Binding+Map.swift
//
//
//  Created by Edon Valdman on 6/22/24.
//

import SwiftUI

extension Binding {
    func map<T>(
        _ keyPath: WritableKeyPath<Value, T>
    ) -> Binding<T> {
        Binding<T>(
            get: { wrappedValue[keyPath: keyPath] },
            set: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }
    
    func map<T>(
        transform: @escaping (Value) -> T,
        reverse : @escaping (T) -> Value
    ) -> Binding<T> {
        Binding<T>(
            get: { transform(self.wrappedValue) },
            set: { wrappedValue = reverse($0) }
        )
    }
    
    func map<T, U>(
        transform: @escaping (T) -> U,
        reverse : @escaping (U) -> T
    ) -> Binding<U?> where Value == Optional<T> {
        Binding<U?>(
            get: { self.wrappedValue.map(transform) },
            set: { wrappedValue = $0.map(reverse) }
        )
    }
}
