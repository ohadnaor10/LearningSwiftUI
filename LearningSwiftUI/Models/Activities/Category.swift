//
//  Category.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 22/11/2025.
//

import Foundation

/// A node in the activity reporting tree.
/// Each category can contain inputs (depending on its type)
/// and can lead to one or more subcategories.
struct Category: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var type: CategoryType
    var subcategories: [Category]

    init(
        id: UUID = UUID(),
        name: String,
        type: CategoryType,
        subcategories: [Category] = []
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.subcategories = subcategories
    }
}
