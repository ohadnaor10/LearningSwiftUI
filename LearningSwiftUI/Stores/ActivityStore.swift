//
//  ActivityStore.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import SwiftUI

/// Central place to hold the user’s activity definitions and navigation state
/// for the Report page (folders, activities, pinned, etc.).
final class ActivityStore: ObservableObject {

    /// Root of the folder tree (usually "All")
    @Published var rootFolder: ActivityFolder

    /// Stack of folders representing the current navigation path
    @Published private(set) var folderStack: [ActivityFolder]

    /// Activities shown in the pinned bar
    @Published var pinnedActivities: [ActivityType]

    /// The folder currently being displayed in the UI
    var currentFolder: ActivityFolder {
        folderStack.last ?? rootFolder
    }

    init(
        rootFolder: ActivityFolder = .sampleTree,
        pinnedActivities: [ActivityType] = ActivityType.samples
    ) {
        self.rootFolder = rootFolder
        self.folderStack = []
        self.pinnedActivities = pinnedActivities
    }

    // MARK: - Navigation

    func push(folder: ActivityFolder) {
        folderStack.append(folder)
    }

    func popFolder() {
        _ = folderStack.popLast()
    }

    func resetNavigation() {
        folderStack.removeAll()
    }

    // MARK: - Future mutations (stubs for now)

    /// Replace the whole root folder tree (e.g. after loading from disk).
    func setRootFolder(_ folder: ActivityFolder) {
        rootFolder = folder
        resetNavigation()
    }

    /// Add a new activity somewhere in the tree (to be implemented later).
    func addActivity(_ activity: ActivityType, to folder: ActivityFolder) {
        // TODO: implement mutation logic when you define how editing works.
    }

    /// Add a new folder somewhere in the tree (to be implemented later).
    func addFolder(named name: String, to folder: ActivityFolder) {
        // TODO: implement mutation logic when you define how editing works.
    }
}
