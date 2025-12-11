//
//  ActivityInstanceStore.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 06/12/2025.
//

import Foundation

struct ActivityInstance: Identifiable, Hashable, Codable {
    let id: UUID = UUID()
    let activityID: UUID
    var timestamp: Date

    // categoryID → attribute values
    var values: [UUID: CategoryValue]
}


enum CategoryValue: Hashable, Codable {
    case choice([UUID])          // selected choice IDs
    case number([UUID: Int])     // inputID → number
    case text([UUID: String])    // inputID → text
    case time(Date)
}
