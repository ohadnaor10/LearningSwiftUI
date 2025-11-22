//
//  Activity.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 22/11/2025.
//

import Foundation

/// A user-defined activity.
/// It only contains:
/// 1. A name
/// 2. A pointer to the starting category of its reporting tree.
struct Activity: Identifiable, Hashable {
    let id: UUID
    var name: String
    var startingCategory: Category

    init(id: UUID = UUID(), name: String, startingCategory: Category) {
        self.id = id
        self.name = name
        self.startingCategory = startingCategory
    }
}
