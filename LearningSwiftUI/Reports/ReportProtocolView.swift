//
//  ReportProtocolView.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import SwiftUI

struct ReportProtocolView: View {
    let activity: Activity

    var body: some View {
        VStack(spacing: 16) {
            Text("Report activity")
                .font(.headline)

            Text("\(activity.icon) \(activity.name)")
                .font(.title3)

            Text("This is a placeholder for the future report protocol flow.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ReportProtocolView(
        activity: Activity(name: "Drink water", icon: "💧")
    )
}
