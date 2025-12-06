//
//  ChooseTimePage.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 06/12/2025.
//

import SwiftUI

struct ChooseTimePage: View {
    let onNow: () -> Void
    let onEarlier: () -> Void

    var body: some View {
        VStack(spacing: 32) {

            // Title
            VStack(spacing: 8) {
                Text("When did you do this activity?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text("Pick the closest option so we can log it correctly.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.top, 32)

            Spacer()

            // Big "Now" button
            Button(action: onNow) {
                VStack(spacing: 6) {
                    Text("Just now")
                        .font(.headline)

                    Text("Log it as happening right now")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue)
                )
                .foregroundColor(.white)
                .padding(.horizontal, 24)
            }

            // Smaller "Earlier today" button
            Button(action: onEarlier) {
                VStack(spacing: 4) {
                    Text("Earlier today")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text("I did it before, at another time")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }

            Spacer()
        }
    }
}
