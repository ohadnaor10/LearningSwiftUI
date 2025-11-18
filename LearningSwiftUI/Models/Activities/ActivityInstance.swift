//
//  ActivityInstance.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

struct ActivityInstance: Identifiable, Hashable {
    let id: UUID
    let activityTypeId: UUID
    let timestamp: Date
    /// attributeId -> value
    let values: [String: AttributeValue]
}
