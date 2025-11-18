////
////  Activity.swift
////  LearningSwiftUI
////
////  Created by Ohad Naor on 18/11/2025.
////
//
//import Foundation
//
//struct Activity: Identifiable, Hashable {
//    let id = UUID()
//    let name: String
//    let icon: String
//}
//
//struct ActivityFolder: Identifiable, Hashable {
//    let id = UUID()
//    let name: String
//    let items: [ActivityItem]
//}
//
//indirect enum ActivityItem: Identifiable, Hashable {
//    case folder(ActivityFolder)
//    case activity(Activity)
//
//    var id: UUID {
//        switch self {
//        case .folder(let folder):
//            return folder.id
//        case .activity(let activity):
//            return activity.id
//        }
//    }
//}
//
//// MARK: - Sample Data
//
//extension ActivityFolder {
//    static var sampleRoot: ActivityFolder {
//        let sleep = Activity(name: "Going to sleep", icon: "😴")
//        let wake = Activity(name: "Waking up", icon: "⏰")
//        let meal = Activity(name: "Eating a meal", icon: "🍽")
//        let water = Activity(name: "Drinking water", icon: "💧")
//        let workStart = Activity(name: "Start work", icon: "💻")
//        let friends = Activity(name: "Hanging out with friends", icon: "🧑‍🤝‍🧑")
//
//        let healthFolder = ActivityFolder(
//            name: "Health",
//            items: [
//                .activity(water),
//                .activity(meal),
//                .activity(sleep),
//                .activity(wake)
//            ]
//        )
//
//        let sportFolder = ActivityFolder(
//            name: "Sport",
//            items: [
//                .activity(Activity(name: "Workout", icon: "🏋️‍♂️")),
//                .activity(Activity(name: "Run", icon: "🏃‍♂️"))
//            ]
//        )
//
//        let expensesFolder = ActivityFolder(
//            name: "Expenses",
//            items: [
//                .folder(
//                    ActivityFolder(
//                        name: "Necessary",
//                        items: [
//                            .activity(Activity(name: "Groceries", icon: "🛒")),
//                            .activity(Activity(name: "Rent", icon: "🏠"))
//                        ]
//                    )
//                ),
//                .folder(
//                    ActivityFolder(
//                        name: "Not necessary",
//                        items: [
//                            .activity(Activity(name: "Takeaway", icon: "🍕")),
//                            .activity(Activity(name: "Shopping", icon: "🛍"))
//                        ]
//                    )
//                )
//            ]
//        )
//
//        let activitiesFolder = ActivityFolder(
//            name: "Activities",
//            items: [
//                .activity(workStart),
//                .activity(friends)
//            ]
//        )
//
//        return ActivityFolder(
//            name: "All",
//            items: [
//                .folder(healthFolder),
//                .folder(expensesFolder),
//                .folder(sportFolder),
//                .folder(activitiesFolder),
//                .activity(Activity(name: "Random note", icon: "📝"))
//            ]
//        )
//    }
//}
//
//extension Activity {
//    static var samplePinned: [Activity] {
//        [
//            Activity(name: "Drink water", icon: "💧"),
//            Activity(name: "Going to sleep", icon: "😴"),
//            Activity(name: "Start work", icon: "💻"),
//            Activity(name: "Meal", icon: "🍽")
//        ]
//    }
//}
