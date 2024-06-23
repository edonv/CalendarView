//
//  Array+Duplicates.swift
//
//
//  Created by Edon Valdman on 6/23/24.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> Self {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
}
