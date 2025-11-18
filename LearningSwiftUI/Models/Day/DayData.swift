//
//  DayData.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 17/11/2025.
//

import Foundation

struct DayData: Codable {
    var events: [Event]
    var tasks: [Task]
    var completedHabits: Set<UUID>   // store only habit IDs
    
    init(events: [Event] = [],
         tasks: [Task] = [],
         completedHabits: Set<UUID> = []) {
        self.events = events
        self.tasks = tasks
        self.completedHabits = completedHabits
    }
}
