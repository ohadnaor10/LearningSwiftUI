//
//  Event.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 15/11/2025.
//

import Foundation

struct Event: Identifiable, Codable {
    let id: UUID
    var title: String
    var startTime: Date?
    var endTime: Date?
    var notes: String?
    
    init(title: String,
         startTime: Date? = nil,
         endTime: Date? = nil,
         notes: String? = nil) {
        self.id = UUID()
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
    }
}
