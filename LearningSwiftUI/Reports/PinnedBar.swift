//
//  PinnedBar.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import SwiftUI

struct PinnedBar: View {
    let pinnedActivities: [Activity]
    let onTap: (Activity) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(pinnedActivities) { activity in
                    Button {
                        onTap(activity)
                    } label: {
                        HStack(spacing: 6) {
                            Text(activity.icon)
                            Text(activity.name)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    PinnedBar(
        pinnedActivities: Activity.samplePinned,
        onTap: { _ in }
    )
}
