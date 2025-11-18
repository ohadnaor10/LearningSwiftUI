//
//  FlowRouting.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

enum FlowRouting: Hashable {
    case end
    case linear(nextId: String)
    /// choice value string -> next node id
    case branching(choiceMap: [String: String])
}
