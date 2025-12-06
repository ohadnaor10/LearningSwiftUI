//
//  GroupCard.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 22/11/2025.
//
import SwiftUI

struct GroupCard: View {
    let group: ActivityGroup
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {

                Text(group.name)
                    .font(.headline)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(group.activities) { activity in
                            Text(activity.name)
                                .font(.subheadline)
                                .padding(6)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(8)
                        }

                        if group.activities.isEmpty {
                            Text("No activities")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 8)
                }

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(group.subgroups) { subgroup in
                        Text("• \(subgroup.name)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }

                    if group.subgroups.isEmpty {
                        Text("No subgroups")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)

            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.12))
            )
        }
        .buttonStyle(.plain)
    }
}
//
//#Preview {
//    let cat = Category(
//        name: "Main",
//        type: .textInputs(TextInputsData(inputs: []))
//    )
//
//    let a1 = Activity(name: "Water", startingCategory: cat)
//    let a2 = Activity(name: "Workout", startingCategory: cat)
//
//    let subgroup1 = ActivityGroup(name: "Health", subgroups: [], activities: [a1])
//    let subgroup2 = ActivityGroup(name: "Work", subgroups: [], activities: [a2])
//
//    let root = ActivityGroup(
//        name: "Root Group",
//        subgroups: [subgroup1, subgroup2],
//        activities: [a1, a2]
//    )
//
//    return GroupCard(group: root) { }
//}
