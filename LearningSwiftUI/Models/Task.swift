//
//  Task.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 17/11/2025.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isDone: Bool
    
    init(title: String, isDone: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isDone = isDone
    }
}
