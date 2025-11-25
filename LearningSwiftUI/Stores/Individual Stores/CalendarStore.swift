//
//  CalendarStore.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 17/11/2025.
//

import Foundation
import SwiftUI


final class CalendarStore: ObservableObject {
    @Published private(set) var days: [DayKey: DayData] = [:]
}

//import SwiftUI
//
///// Holds calendar-related state, mainly the currently displayed month.
///// Later you can extend this to hold events, tasks, etc.
//final class CalendarStore: ObservableObject {
//
//    /// The month currently shown in the calendar UI
//    @Published var currentMonth: Month
//
//    init(currentMonth: Month = .current) {
//        self.currentMonth = currentMonth
//    }
//
//    // MARK: - Navigation
//
//    func goToToday() {
//        currentMonth = .current
//    }
//
//    func advance(by offset: Int) {
//        currentMonth = currentMonth.advanced(by: offset)
//    }
//
//    func nextMonth() {
//        advance(by: 1)
//    }
//
//    func previousMonth() {
//        advance(by: -1)
//    }
//}
