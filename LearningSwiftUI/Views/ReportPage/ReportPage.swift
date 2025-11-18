import SwiftUI

struct ReportPage: View {
    @State private var rootFolder: ActivityFolder = .sampleTree
    @State private var folderStack: [ActivityFolder] = []

    @State private var showAddPanel = false
    @State private var activeActivityType: ActivityType?

    private var currentFolder: ActivityFolder {
        folderStack.last ?? rootFolder
    }

    private var topTitle: String {
        folderStack.isEmpty ? "Report your activities" : currentFolder.name
    }

    private var pinnedActivities: [ActivityType] {
        ActivityType.samples
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            PinnedBar(
                pinnedActivities: pinnedActivities,
                onTap: { activity in
                    activeActivityType = activity
                }
            )
            Divider()
            contentList
        }
        .sheet(isPresented: $showAddPanel) {
            AddPanelView()
        }
        .sheet(item: $activeActivityType) { activityType in
            ReportProtocolView(activityType: activityType)
        }
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            if !folderStack.isEmpty {
                Button {
                    withAnimation(.easeOut(duration: 0.25)) { () -> Void in
                        folderStack.removeLast()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.subheadline)
                    }
                }
                .buttonStyle(.plain)
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
        .background(Color(white: 0.9))   // simple light gray background, no opacity()
    }


    // MARK: - Content

    private var contentList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(currentFolder.items) { node in
                    ActivityCard(
                        node: node,
                        onOpenFolder: { folder in
                            folderStack.append(folder)
                        },
                        onSelectActivity: { activityType in
                            activeActivityType = activityType
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Sample tree

extension ActivityFolder {
    static let sampleTree: ActivityFolder = {
        let water = ActivityType.drinkWater
        let workout = ActivityType.workout
        let sleep = ActivityType.sleep

        let health = ActivityFolder(
            name: "Health",
            items: [
                .activity(water),
                .activity(sleep)
            ]
        )

        let sport = ActivityFolder(
            name: "Sport",
            items: [
                .activity(workout)
            ]
        )

        return ActivityFolder(
            name: "All",
            items: [
                .folder(health),
                .folder(sport)
            ]
        )
    }()
}

#Preview {
    ReportPage()
}
