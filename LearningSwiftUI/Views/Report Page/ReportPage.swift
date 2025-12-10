import SwiftUI

struct ReportPage: View {

    @Binding var showAddMenu: Bool
    @Binding var backTrigger: Int      // ← NEW
    
    @State private var showAddActivityFlow = false
    @State private var showAddGroupFlow = false
    @State private var showReportActivityFlow = false
    
    @EnvironmentObject var userData: UserData
    
    @State private var selectedActivityID: UUID? = nil
    @State private var selectedActivityIndex: Int? = nil
    
    @State private var currentGroupIndex: Int = 0
    @State private var currentSubgroupID: UUID? = nil   // ← NEW
    @State private var subgroupPath: [Int] = []    // ← NEW
    
    var body: some View {
        ZStack {
            // -------------------------
            // MAIN CONTENT
            // -------------------------
            if userData.groups.indices.contains(currentGroupIndex) {
                ContentPage(
                    group: currentGroupBinding,
                    onSelectActivity: { activity, index in
                        selectedActivityID = activity.id
                        selectedActivityIndex = index
                        showReportActivityFlow = true
                    },
                    onSelectGroup: { subgroup in
                        // Find this subgroup inside the CURRENT group's subgroups
                        let current = getGroup(at: subgroupPath,
                                               in: userData.groups[currentGroupIndex])
                        
                        if let idx = current.subgroups.firstIndex(where: { $0.id == subgroup.id }) {
                            // Go one step deeper in the path: current → its subgroup
                            subgroupPath.append(idx)
                        }
                    }
                )
            } else {
                Text("No groups yet")
            }

            // -------------------------
            // ADD MENU OVERLAY
            // -------------------------
            if showAddMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showAddMenu = false
                        }
                    }

                VStack {
                    Spacer()
                    VStack(spacing: 16) {

                        Button("Add Activity") {
                            withAnimation {
                                showAddMenu = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                showAddActivityFlow = true
                            }
                        }
                        .font(.headline)

                        Button("Add Group") {
                            withAnimation {
                                showAddMenu = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                showAddGroupFlow = true
                            }
                        }
                        .font(.headline)

                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(white: 0.95))
                    .cornerRadius(20)
                    .padding(.horizontal, 8)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.25), value: showAddMenu)
            }
        }

        // -------------------------
        // SHEETS
        // -------------------------
        .sheet(isPresented: $showAddActivityFlow) {
            AddActivityPage(group: currentGroupBinding)
                .environmentObject(userData)
        }
        .sheet(isPresented: $showAddGroupFlow) {
            AddGroupPage(group: currentGroupBinding)
                .environmentObject(userData)
        }
        .sheet(isPresented: $showReportActivityFlow) {
            if let activityBinding = selectedActivityBinding {
                ReportActivityPage(activity: activityBinding)
                    .environmentObject(userData)
            } else {
                Text("Loading…")
            }
        }
        .onChange(of: backTrigger) { _ in
            handleBackTapped()
        }
    }
    
    // -------------------------
    // GROUP BINDING HELPER
    // -------------------------
    private var currentGroupBinding: Binding<ActivityGroup> {
        Binding(
            get: {
                getGroup(
                    at: subgroupPath,
                    in: userData.groups[currentGroupIndex]
                )
            },
            set: { newValue in
                setGroup(
                    newValue,
                    at: subgroupPath,
                    in: &userData.groups[currentGroupIndex]
                )
            }
        )
    }
    
    
    private var selectedActivityBinding: Binding<Activity>? {
        guard
            let index = selectedActivityIndex,
            userData.groups.indices.contains(currentGroupIndex)
        else {
            return nil
        }

        // Optional, safety on subgroupPath
        let group = getGroup(
            at: subgroupPath,
            in: userData.groups[currentGroupIndex]
        )
        guard group.activities.indices.contains(index) else {
            return nil
        }

        return Binding(
            get: {
                let group = getGroup(
                    at: subgroupPath,
                    in: userData.groups[currentGroupIndex]
                )
                return group.activities[index]
            },
            set: { newValue in
                var group = getGroup(
                    at: subgroupPath,
                    in: userData.groups[currentGroupIndex]
                )
                group.activities[index] = newValue

                setGroup(
                    group,
                    at: subgroupPath,
                    in: &userData.groups[currentGroupIndex]
                )
            }
        )
    }

    
    // Walk down the subgroupPath to get the current group
    private func getGroup(at path: [Int], in root: ActivityGroup) -> ActivityGroup {
        var group = root
        for idx in path {
            group = group.subgroups[idx]
        }
        return group
    }

    // Walk down the path and replace the group at that location
    private func setGroup(_ newGroup: ActivityGroup,
                          at path: [Int],
                          in root: inout ActivityGroup) {
        func set(in group: inout ActivityGroup,
                 pathSlice: ArraySlice<Int>,
                 newGroup: ActivityGroup) {
            guard let first = pathSlice.first else {
                group = newGroup
                return
            }
            if pathSlice.count == 1 {
                group.subgroups[first] = newGroup
            } else {
                set(in: &group.subgroups[first],
                    pathSlice: pathSlice.dropFirst(),
                    newGroup: newGroup)
            }
        }

        set(in: &root, pathSlice: ArraySlice(path), newGroup: newGroup)
    }
    
    private func handleBackTapped() {
        // Example: path based navigation
        if !subgroupPath.isEmpty {
            subgroupPath.removeLast()
        }
        // If you are still at root (subgroupPath empty),
        // do nothing. Arrow visibility control can come later.
    }

}
