import SwiftUI

enum SampleData {
    static let groups: [ActivityGroup] = [
        
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
}

