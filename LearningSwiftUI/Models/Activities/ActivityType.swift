//
//  ActivityType.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

struct ActivityType: Identifiable, Hashable {
    let id: UUID
    let name: String
    let icon: String

    /// Root node id in the flow graph
    let rootNodeId: String
    /// All nodes in the flow, keyed by id
    let nodes: [String: FlowNode]
    /// Attribute definitions for this activity, keyed by attribute id
    let attributes: [String: AttributeDefinition]

    var allAttributes: [AttributeDefinition] {
        Array(attributes.values)
    }
}

// MARK: - Sample activities

extension ActivityType {

    /// Drink water - one question: "How many ml?"
    static let drinkWater: ActivityType = {
        // Attributes
        let mlAttr = AttributeDefinition(
            id: "ml",
            displayName: "Milliliters",
            kind: .number
        )

        // Flow
        let qMl = FlowQuestion(
            id: "q_ml",
            prompt: "How many ml did you drink?",
            inputKind: .number,
            choices: nil,
            boundAttributeId: "ml"
        )

        let nodeId = "drink_water_ml"
        let node = FlowNode(
            id: nodeId,
            title: "Drink water",
            questions: [qMl],
            routing: .end
        )

        return ActivityType(
            id: UUID(),
            name: "Drink water",
            icon: "💧",
            rootNodeId: nodeId,
            nodes: [nodeId: node],
            attributes: ["ml": mlAttr]
        )
    }()

    /// Workout with branching A/B
    static let workout: ActivityType = {
        // Attributes
        let typeAttr = AttributeDefinition(
            id: "workoutType",
            displayName: "Workout type",
            kind: .choice,
            choices: ["A", "B"]
        )

        let benchSetsAttr = AttributeDefinition(
            id: "benchSets",
            displayName: "Bench sets",
            kind: .number
        )

        let benchKgAttr = AttributeDefinition(
            id: "benchKg",
            displayName: "Bench weight (kg)",
            kind: .number
        )

        let pulleyWeightAttr = AttributeDefinition(
            id: "pulleyWeight",
            displayName: "Pulley weight",
            kind: .number
        )

        // Nodes
        let qType = FlowQuestion(
            id: "q_workout_type",
            prompt: "Which workout?",
            inputKind: .choice,
            choices: ["A", "B"],
            boundAttributeId: "workoutType"
        )

        let nodeTypeId = "workout_type"
        let nodeType = FlowNode(
            id: nodeTypeId,
            title: "Workout",
            questions: [qType],
            routing: .branching(choiceMap: [
                "A": "workout_bench",
                "B": "workout_pulley"
            ])
        )

        let qBenchSets = FlowQuestion(
            id: "q_bench_sets",
            prompt: "Bench sets",
            inputKind: .number,
            choices: nil,
            boundAttributeId: "benchSets"
        )

        let qBenchKg = FlowQuestion(
            id: "q_bench_kg",
            prompt: "Bench weight (kg)",
            inputKind: .number,
            choices: nil,
            boundAttributeId: "benchKg"
        )

        let nodeBenchId = "workout_bench"
        let nodeBench = FlowNode(
            id: nodeBenchId,
            title: "Bench workout",
            questions: [qBenchSets, qBenchKg],
            routing: .end
        )

        let qPulleyWeight = FlowQuestion(
            id: "q_pulley_weight",
            prompt: "Pulley weight",
            inputKind: .number,
            choices: nil,
            boundAttributeId: "pulleyWeight"
        )

        let nodePulleyId = "workout_pulley"
        let nodePulley = FlowNode(
            id: nodePulleyId,
            title: "Pulley workout",
            questions: [qPulleyWeight],
            routing: .end
        )

        var nodes: [String: FlowNode] = [:]
        nodes[nodeTypeId] = nodeType
        nodes[nodeBenchId] = nodeBench
        nodes[nodePulleyId] = nodePulley

        let attrs: [String: AttributeDefinition] = [
            typeAttr.id: typeAttr,
            benchSetsAttr.id: benchSetsAttr,
            benchKgAttr.id: benchKgAttr,
            pulleyWeightAttr.id: pulleyWeightAttr
        ]

        return ActivityType(
            id: UUID(),
            name: "Workout",
            icon: "🏋️‍♂️",
            rootNodeId: nodeTypeId,
            nodes: nodes,
            attributes: attrs
        )
    }()

    /// Simple "Going to sleep" example, asks for planned wake up time as text
    static let sleep: ActivityType = {
        let wakeAttr = AttributeDefinition(
            id: "plannedWake",
            displayName: "Planned wake up time",
            kind: .text
        )

        let qWake = FlowQuestion(
            id: "q_planned_wake",
            prompt: "When do you plan to wake up?",
            inputKind: .text,
            choices: nil,
            boundAttributeId: "plannedWake"
        )

        let nodeId = "sleep_main"
        let node = FlowNode(
            id: nodeId,
            title: "Sleep",
            questions: [qWake],
            routing: .end
        )

        return ActivityType(
            id: UUID(),
            name: "Going to sleep",
            icon: "😴",
            rootNodeId: nodeId,
            nodes: [nodeId: node],
            attributes: ["plannedWake": wakeAttr]
        )
    }()

    static let samples: [ActivityType] = [
        .drinkWater,
        .workout,
        .sleep
    ]
}
