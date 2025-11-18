//
//  FlowNode.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

struct FlowNode: Identifiable, Hashable {
    /// Node id used in routing
    let id: String
    /// Optional page title
    let title: String?
    /// Questions shown on this page
    let questions: [FlowQuestion]
    /// Where to go after this page
    let routing: FlowRouting

    init(id: String,
         title: String? = nil,
         questions: [FlowQuestion],
         routing: FlowRouting) {
        self.id = id
        self.title = title
        self.questions = questions
        self.routing = routing
    }
}
