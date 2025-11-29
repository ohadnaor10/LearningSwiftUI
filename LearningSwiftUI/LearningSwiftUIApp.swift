//
//  LearningSwiftUIApp.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

@main
struct LearningSwiftUIApp: App {
    @StateObject var userData = UserData()

    var body: some Scene {
        WindowGroup {
            AppShell()
                .environmentObject(userData)
        }
    }
}
