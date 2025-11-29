//
//  AddActivityNameStep.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 27/11/2025.
//

import SwiftUI

struct AddActivityNameStep: View {
    @Binding var activityName: String
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            // Title
            Text("Create a New Activity")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 32)

            Spacer()

            // Input field
            VStack(alignment: .leading, spacing: 8) {
                Text("Activity Name")
                    .font(.headline)
                    .foregroundColor(.primary)

                TextField("Enter name...", text: $activityName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .font(.system(size: 18))
            }
            .padding(.horizontal, 24)

            Spacer()

            // NEXT BUTTON
            Button(action: {
                if !activityName.trimmingCharacters(in: .whitespaces).isEmpty {
                    onNext()
                }
            }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        activityName.trimmingCharacters(in: .whitespaces).isEmpty
                        ? Color.gray.opacity(0.4)
                        : Color.blue
                    )
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            .disabled(activityName.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}
