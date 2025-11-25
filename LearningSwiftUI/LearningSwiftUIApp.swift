//
//  LearningSwiftUIApp.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

@main
struct LearningSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            AppShell()
                .environmentObject(GroupsStore())
        }
    }
}
