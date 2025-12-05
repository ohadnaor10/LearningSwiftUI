import SwiftUI

struct ReportPage: View {

    @Binding var showAddMenu: Bool
    @State private var showAddActivityFlow = false
    @State private var showAddGroupFlow = false
    @EnvironmentObject var userData: UserData
    
    @State private var currentGroupIndex: Int = 0
    
    var body: some View {
        ZStack {
            // -------------------------
            // MAIN CONTENT
            // -------------------------
            if userData.groups.indices.contains(currentGroupIndex) {
                ContentPage(
                    group: currentGroupBinding,
                    onSelectActivity: { _ in },
                    onSelectGroup: { subgroup in
                        // navigate to subgroup if root-level
                        if let idx = userData.groups.firstIndex(where: { $0.id == subgroup.id }) {
                            currentGroupIndex = idx
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
            AddGroupPage()
                .environmentObject(userData)
        }
    }
    
    // -------------------------
    // GROUP BINDING HELPER
    // -------------------------
    private var currentGroupBinding: Binding<ActivityGroup> {
        Binding(
            get: {
                userData.groups[currentGroupIndex]
            },
            set: { newValue in
                userData.groups[currentGroupIndex] = newValue
            }
        )
    }
}
