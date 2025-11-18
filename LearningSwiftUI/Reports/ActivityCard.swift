//
//  ActivityCard.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import SwiftUI

struct ActivityCard: View {
    let item: ActivityItem
    let onOpenFolder: (ActivityFolder) -> Void
    let onSelectActivity: (Activity) -> Void

    var body: some View {
        switch item {
        case .folder(let folder):
            folderCard(folder)
        case .activity(let activity):
            activityRow(activity)
        }
    }

    private func folderCard(_ folder: ActivityFolder) -> some View {
        Button {
            onOpenFolder(folder)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(folder.name)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "ellipsis.vertical")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    let preview = folder.items.prefix(3)
                    ForEach(Array(preview)) { child in
                        switch child {
                        case .folder(let subFolder):
                            Text("📁 \(subFolder.name)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        case .activity(let activity):
                            Text("\(activity.icon) \(activity.name)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    if folder.items.count > 3 {
                        Text("…")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private func activityRow(_ activity: Activity) -> some View {
        Button {
            onSelectActivity(activity)
        } label: {
            HStack {
                Text(activity.icon)
                    .font(.title3)
                Text(activity.name)
                    .font(.body)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
