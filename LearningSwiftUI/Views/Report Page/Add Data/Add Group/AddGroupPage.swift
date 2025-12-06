//
//  AddGroupPage.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 25/11/2025.
//

import SwiftUI

struct AddGroupPage: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userData: UserData

    @Binding var group: ActivityGroup      // binding to the current group

    @State private var name: String = ""

    var body: some View {
        VStack(spacing: 24) {

            Text("Create New Group")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 24)

            TextField("Group name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)

            Spacer()

            Button(action: completeGroup) {
                Text("Create Group")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }

    private func completeGroup() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let newGroup = ActivityGroup(
            name: trimmed,
            subgroups: [],
            activities: []
        )

        group.subgroups.append(newGroup)     // ← adds into the correct group
        dismiss()
    }
}



//Button("Save") {
//    groupsStore.groups.append(ActivityGroup(id: UUID(), name: name))
//    dismiss()
//}
