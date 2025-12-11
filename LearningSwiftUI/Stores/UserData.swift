//
//  UserData.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 25/11/2025.
//
import Foundation


final class UserData: ObservableObject, Codable {
    @Published var activities: [Activity] = []
    @Published var groups: [ActivityGroup] = [
        ActivityGroup(
            name: "Root Group",
            activities: [
                Activity(name: "Gym Workout", categories: []),
                Activity(name: "Running", categories: [])
            ]
        )
    ]
    @Published var activityInstances: [ActivityInstance] = []
    
    // MARK: - CodingKeys for Codable
    enum CodingKeys: String, CodingKey {
        case activities
        case groups
        case activityInstances
    }

    // Default init for “empty” data
    init() {}

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activities = try container.decode([Activity].self, forKey: .activities)
        groups = try container.decode([ActivityGroup].self, forKey: .groups)
        activityInstances = try container.decode([ActivityInstance].self, forKey: .activityInstances)
    }

    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activities, forKey: .activities)
        try container.encode(groups, forKey: .groups)
        try container.encode(activityInstances, forKey: .activityInstances)
    }
}

extension UserData {
    private static var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("UserData.json")
    }
    func saveToDisk() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601    // good default for Date
            let data = try encoder.encode(self)
            try data.write(to: Self.fileURL, options: .atomic)
        } catch {
            print("❌ Failed to save UserData:", error)
        }
    }
    static func loadFromDisk() -> UserData {
        do {
            let url = fileURL
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode(UserData.self, from: data)
            return decoded
        } catch {
            print("⚠️ Failed to load UserData, using empty. Error:", error)
            return UserData()
        }
    }
}
