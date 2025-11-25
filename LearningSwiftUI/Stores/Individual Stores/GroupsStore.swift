//
//  GroupsStore.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 25/11/2025.
//

import Foundation


class GroupsStore: ObservableObject {
    @Published var groups: [ActivityGroup] = []
}

