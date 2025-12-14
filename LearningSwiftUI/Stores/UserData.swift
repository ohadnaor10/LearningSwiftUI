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

        // --------------------------------------------------
        // ROOT GROUP
        // --------------------------------------------------
        ActivityGroup(
            name: "Life",
            subgroups: [

                // -------------------------
                // FITNESS
                // -------------------------
                ActivityGroup(
                    name: "Fitness",
                    activities: [

                        Activity(
                            name: "Gym Workout",
                            categories: [

                                // ---- Workout Type (choice with children)
                                Category(
                                    name: "Workout Type",
                                    type: .choice(
                                        ChoiceData(choices: [
                                            Choice(
                                                name: "Strength",
                                                isOn: false,
                                                hasChildren: true,
                                                subcategories: [

                                                    Category(
                                                        name: "Muscle Group",
                                                        type: .choice(
                                                            ChoiceData(choices: [
                                                                Choice(name: "Chest", isOn: false, hasChildren: false),
                                                                Choice(name: "Back", isOn: false, hasChildren: false),
                                                                Choice(name: "Legs", isOn: false, hasChildren: false),
                                                                Choice(name: "Shoulders", isOn: false, hasChildren: false)
                                                            ])
                                                        )
                                                    ),

                                                    Category(
                                                        name: "Intensity",
                                                        type: .numberInputs(
                                                            NumberInputsData(inputs: [
                                                                NumberInput(name: "RPE", inValue: nil)
                                                            ])
                                                        )
                                                    )
                                                ]
                                            ),

                                            Choice(
                                                name: "Cardio",
                                                isOn: false,
                                                hasChildren: true,
                                                subcategories: [

                                                    Category(
                                                        name: "Cardio Type",
                                                        type: .choice(
                                                            ChoiceData(choices: [
                                                                Choice(name: "Treadmill", isOn: false, hasChildren: false),
                                                                Choice(name: "Bike", isOn: false, hasChildren: false),
                                                                Choice(name: "Rowing", isOn: false, hasChildren: false)
                                                            ])
                                                        )
                                                    ),

                                                    Category(
                                                        name: "Duration",
                                                        type: .numberInputs(
                                                            NumberInputsData(inputs: [
                                                                NumberInput(name: "Minutes", inValue: nil)
                                                            ])
                                                        )
                                                    )
                                                ]
                                            )
                                        ])
                                    )
                                ),

                                // ---- Notes
                                Category(
                                    name: "Notes",
                                    type: .textInputs(
                                        TextInputsData(inputs: [
                                            TextInput(name: "How did it feel?", inValue: nil)
                                        ])
                                    )
                                )
                            ]
                        ),

                        Activity(
                            name: "Running",
                            categories: [

                                Category(
                                    name: "Distance",
                                    type: .numberInputs(
                                        NumberInputsData(inputs: [
                                            NumberInput(name: "Kilometers", inValue: nil)
                                        ])
                                    )
                                ),

                                Category(
                                    name: "Pace",
                                    type: .numberInputs(
                                        NumberInputsData(inputs: [
                                            NumberInput(name: "Minutes per km", inValue: nil)
                                        ])
                                    )
                                ),

                                Category(
                                    name: "Surface",
                                    type: .choice(
                                        ChoiceData(choices: [
                                            Choice(name: "Road", isOn: false, hasChildren: false),
                                            Choice(name: "Trail", isOn: false, hasChildren: false),
                                            Choice(name: "Track", isOn: false, hasChildren: false)
                                        ])
                                    )
                                )
                            ]
                        )
                    ]
                ),

                // -------------------------
                // STUDY
                // -------------------------
                ActivityGroup(
                    name: "Study",
                    activities: [

                        Activity(
                            name: "Math Study Session",
                            categories: [

                                Category(
                                    name: "Topic",
                                    type: .choice(
                                        ChoiceData(choices: [
                                            Choice(name: "Calculus", isOn: false, hasChildren: false),
                                            Choice(name: "Linear Algebra", isOn: false, hasChildren: false),
                                            Choice(name: "Probability", isOn: false, hasChildren: false)
                                        ])
                                    )
                                ),

                                Category(
                                    name: "Duration",
                                    type: .numberInputs(
                                        NumberInputsData(inputs: [
                                            NumberInput(name: "Minutes", inValue: nil)
                                        ])
                                    )
                                ),

                                Category(
                                    name: "Focus Level",
                                    type: .choice(
                                        ChoiceData(choices: [
                                            Choice(name: "Low", isOn: false, hasChildren: false),
                                            Choice(name: "Medium", isOn: false, hasChildren: false),
                                            Choice(name: "High", isOn: false, hasChildren: false)
                                        ])
                                    )
                                )
                            ]
                        )
                    ]
                ),

                // -------------------------
                // PERSONAL
                // -------------------------
                ActivityGroup(
                    name: "Personal",
                    activities: [

                        Activity(
                            name: "Meditation",
                            categories: [

                                Category(
                                    name: "Style",
                                    type: .choice(
                                        ChoiceData(choices: [
                                            Choice(name: "Breathing", isOn: false, hasChildren: false),
                                            Choice(name: "Body Scan", isOn: false, hasChildren: false),
                                            Choice(name: "Guided", isOn: false, hasChildren: false)
                                        ])
                                    )
                                ),

                                Category(
                                    name: "Duration",
                                    type: .numberInputs(
                                        NumberInputsData(inputs: [
                                            NumberInput(name: "Minutes", inValue: nil)
                                        ])
                                    )
                                ),

                                Category(
                                    name: "Reflection",
                                    type: .textInputs(
                                        TextInputsData(inputs: [
                                            TextInput(name: "Thoughts after", inValue: nil)
                                        ])
                                    )
                                )
                            ]
                        )
                    ]
                )
            ],
            activities: []
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
