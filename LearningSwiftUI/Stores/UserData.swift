//
//  UserData.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 25/11/2025.
//
import Foundation


final class UserData: ObservableObject {
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
}

