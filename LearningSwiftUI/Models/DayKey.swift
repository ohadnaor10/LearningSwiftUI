//
//  DayKey.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 15/11/2025.
//

import Foundation

struct DayKey: Hashable, Codable {
    let year: Int
    let month: Int
    let day: Int
}

extension DayKey {
    init(date: Date) {
        let c = Calendar(identifier: .gregorian)
        let comps = c.dateComponents([.year, .month, .day], from: date)
        self.init(year: comps.year!, month: comps.month!, day: comps.day!)
    }
}
