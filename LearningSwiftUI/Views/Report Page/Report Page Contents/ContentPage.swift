import SwiftUI

struct ContentPage: View {

    @Binding var group: ActivityGroup
    let onSelectActivity: (Activity) -> Void
    let onSelectGroup: (ActivityGroup) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text(group.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.horizontal)

            // ACTIVITIES ROW
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(group.activities.enumerated()), id: \.element.id) { _, activity in
                        ActivityCard(
                            activity: activity,
                            onTap: { onSelectActivity(activity) }
                        )
                    }

                    if group.activities.isEmpty {
                        Text("No activities")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                    }
                }
                .padding(.horizontal)
            }

            // SUBGROUPS LIST
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(group.subgroups) { subgroup in
                        GroupCard(
                            group: subgroup,
                            onTap: { onSelectGroup(subgroup) }
                        )
                    }

                    if group.subgroups.isEmpty {
                        Text("No subgroups")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
    }
}
