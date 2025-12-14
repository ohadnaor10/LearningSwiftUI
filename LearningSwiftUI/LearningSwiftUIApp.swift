//
//  LearningSwiftUIApp.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

@main
struct LearningSwiftUIApp: App {
    @StateObject private var userData = UserData.loadFromDisk()

    var body: some Scene {
        WindowGroup {
            AppShell()
                .environmentObject(userData)
                .onChange(of: userData.activities) {
                    userData.saveToDisk()
                }
                .onChange(of: userData.groups) {
                    userData.saveToDisk()
                }
                .onChange(of: userData.activityInstances) {
                    userData.saveToDisk()
                }
        }
    }
}
