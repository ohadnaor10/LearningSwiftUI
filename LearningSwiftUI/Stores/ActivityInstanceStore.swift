//
//  ActivityInstanceStore.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

/// Stores all completed activity reports (instances).
/// For now this is in memory only. Later you can add load/save logic.
final class ActivityInstanceStore: ObservableObject {

    /// All saved instances
    @Published private(set) var instances: [ActivityInstance] = []

    init() { }

    // MARK: - Write

    /// Add a new instance to the store.
    func add(_ instance: ActivityInstance) {
        instances.append(instance)
    }

    /// Convenience: called directly from FlowRunner when a report finishes.
    func add(activityType: ActivityType, values: [String: AttributeValue]) {
        let instance = ActivityInstance(
            id: UUID(),
            activityTypeId: activityType.id,
            timestamp: Date(),
            values: values
        )
        instances.append(instance)
    }

    /// Remove all instances (for debugging or reset).
    func clear() {
        instances.removeAll()
    }

    // MARK: - Read

    /// All instances for a specific activity type.
    func instances(for activityType: ActivityType) -> [ActivityInstance] {
        instances.filter { $0.activityTypeId == activityType.id }
    }

    /// Instances for a specific activity type, ordered by time descending.
    func recentInstances(for activityType: ActivityType, limit: Int? = nil) -> [ActivityInstance] {
        let filtered = instances(for: activityType)
            .sorted { $0.timestamp > $1.timestamp }

        if let limit {
            return Array(filtered.prefix(limit))
        } else {
            return filtered
        }
    }
}
