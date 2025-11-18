//
//  Page2.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

struct ReportPage: View {
    @State private var rootFolder: ActivityFolder = .sampleRoot
    @State private var folderStack: [ActivityFolder] = []

    @State private var showAddPanel = false
    @State private var activeActivity: Activity?

    private var currentFolder: ActivityFolder {
        folderStack.last ?? rootFolder
    }

    private var topTitle: String {
        folderStack.isEmpty ? "Report your activities" : currentFolder.name
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            PinnedBar(
                pinnedActivities: Activity.samplePinned,
                onTap: { activity in
                    activeActivity = activity
                }
            )
            Divider()
            contentList
        }
        .sheet(isPresented: $showAddPanel) {
            AddPanelView()
        }
        .sheet(item: $activeActivity) { activity in
            ReportProtocolView(activity: activity)
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            if !folderStack.isEmpty {
                Button {
                    folderStack.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.trailing, 4)
            }

            Text(topTitle)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            Button {
                showAddPanel = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.15))
    }

    // MARK: - Content

    private var contentList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(currentFolder.items) { item in
                    ActivityCard(
                        item: item,
                        onOpenFolder: { folder in
                            folderStack.append(folder)
                        },
                        onSelectActivity: { activity in
                            activeActivity = activity
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    ReportPage()
}
