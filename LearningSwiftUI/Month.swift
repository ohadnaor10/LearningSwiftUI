//
//  Month.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import Foundation

struct Month: Hashable, Equatable {
    var year: Int
    var month: Int   // 1...12

    static var current: Month {
        let now = Date()
        let c = Calendar.current.dateComponents([.year, .month], from: now)
        return Month(year: c.year!, month: c.month!)
    }

    func next() -> Month {
        var y = year, m = month + 1
        if m > 12 { m = 1; y += 1 }
        return Month(year: y, month: m)
    }

    func previous() -> Month {
        var y = year, m = month - 1
        if m < 1 { m = 12; y -= 1 }
        return Month(year: y, month: m)
    }

    func advanced(by delta: Int) -> Month {
        guard delta != 0 else { return self }
        var y = year, m = month + delta
        y += (m - 1) / 12
        m = ((m - 1) % 12 + 12) % 12 + 1
        return Month(year: y, month: m)
    }

    var title: String {
        var df = DateFormatter()
        df.locale = .current
        df.dateFormat = "LLLL yyyy"      // e.g., November 2025
        let comps = DateComponents(year: year, month: month, day: 1)
        return df.string(from: Calendar.current.date(from: comps)!)
    }
}
