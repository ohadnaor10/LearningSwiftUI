//
//  ContentPage.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 22/11/2025.
//

import SwiftUI

struct ContentPage: View {

//    let group: ActivityGroup
//    let onSelectActivity: (Activity) -> Void
//    let onSelectGroup: (ActivityGroup) -> Void

    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//
//            Text(group.name)
//                .font(.largeTitle)
//                .fontWeight(.semibold)
//                .padding(.horizontal)
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 16) {
//                    ForEach(group.activities) { activity in
//                        ActivityCard(
//                            activity: activity,
//                            onTap: { onSelectActivity(activity) }
//                        )
//                    }
//
//                    if group.activities.isEmpty {
//                        Text("No activities")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .padding(.leading)
//                    }
//                }
//                .padding(.horizontal)
//            }
//
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack(spacing: 16) {
//                    ForEach(group.subgroups) { subgroup in
//                        GroupCard(
//                            group: subgroup,
//                            onTap: { onSelectGroup(subgroup) }
//                        )
//                    }
//
//                    if group.subgroups.isEmpty {
//                        Text("No subgroups")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .padding(.horizontal)
//                    }
//                }
//                .padding(.horizontal)
//            }
//
//            Spacer()
//        }
    }
}

//#Preview {
//
//    let cat = Category(
//        name: "Start",
//        type: .textInputs(TextInputsData(inputs: []))
//    )
//
//    let a1 = Activity(name: "Water", startingCategory: cat)
//    let a2 = Activity(name: "Workout", startingCategory: cat)
//
//    let g1 = ActivityGroup(name: "Health", subgroups: [], activities: [a1])
//    let g2 = ActivityGroup(name: "Work", subgroups: [], activities: [a2])
//
//    let root = ActivityGroup(
//        name: "Root",
//        subgroups: [g1, g2],
//        activities: [a1, a2]
//    )
//
//    return ContentPage(
//        group: root,
//        onSelectActivity: { _ in },
//        onSelectGroup: { _ in }
//    )
//}
