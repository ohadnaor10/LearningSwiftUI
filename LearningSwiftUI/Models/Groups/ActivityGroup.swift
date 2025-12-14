//
//  Group.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 22/11/2025.
//
import Foundation

/// A folder-like environment inside the reporting system.
/// It contains:
/// - A name
/// - Subgroups (nested groups)
/// - Activities (the activities that belong to this group)
struct ActivityGroup: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var subgroups: [ActivityGroup]
    var activities: [Activity]

    init(
        id: UUID = UUID(),
        name: String,
        subgroups: [ActivityGroup] = [],
        activities: [Activity] = []
    ) {
        self.id = id
        self.name = name
        self.subgroups = subgroups
        self.activities = activities
    }
}
