//
//  Habit.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 17/11/2025.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var title: String
    var frequency: HabitFrequency
    var importance: Int       // 1–10 or whatever scale you choose
    
    init(title: String,
         frequency: HabitFrequency,
         importance: Int) {
        self.id = UUID()
        self.title = title
        self.frequency = frequency
        self.importance = importance
    }
}

enum HabitFrequency: String, Codable {
    case daily
    case weekly
    case weekdays
    case weekends
    case custom      // future expansion
}


final class CalendarStore: ObservableObject {
    @Published private(set) var days: [DayKey: DayData] = [:]
    @Published private(set) var habits: [Habit] = []
}
