//
//  AddPanelView.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import SwiftUI

struct AddPanelView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Add new folder or activity")
                .font(.headline)

            Text("This is a placeholder. The real creation bar and logic will be defined later.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}

