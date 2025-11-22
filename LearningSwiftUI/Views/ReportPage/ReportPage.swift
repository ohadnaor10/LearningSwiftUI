import SwiftUI

struct ReportPage: View {

    @State private var rootGroup: ActivityGroup
    @State private var currentGroup: ActivityGroup

    init() {
        let dummyCategory = Category(
            name: "Start",
            type: .textInputs(TextInputsData(inputs: []))
        )

        let dummyActivity = Activity(
            name: "Sample activity",
            startingCategory: dummyCategory
        )

        let root = ActivityGroup(
            name: "Root",
            subgroups: [],
            activities: [dummyActivity]
        )

        _rootGroup = State(initialValue: root)
        _currentGroup = State(initialValue: root)
    }

    var body: some View {
        ContentPage(
            group: currentGroup,
            onSelectActivity: { activity in
                print("Selected activity: \(activity.name)")
            },
            onSelectGroup: { subgroup in
                currentGroup = subgroup
            }
        )
    }
}
