import SwiftUI

struct ReportPage: View {

    @Binding var showAddMenu: Bool
    @State private var showAddActivityFlow = false
    @State private var showAddGroupFlow = false
    @EnvironmentObject var groupsStore: GroupsStore

    var body: some View {
        ZStack {
            // -------------------------------
            // MAIN CONTENT
            // -------------------------------
            ContentPage()

            // -------------------------------
            // ADD MENU OVERLAY
            // -------------------------------
            if showAddMenu {

                // Dimmed background
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showAddMenu = false
                        }
                    }

                // Sliding menu at bottom
                VStack {
                    Spacer()

                    VStack(spacing: 16) {

                        // ADD ACTIVITY
                        Button("Add Activity") {
                            withAnimation {
                                showAddMenu = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                showAddActivityFlow = true
                            }
                        }
                        .font(.headline)

                        // ADD GROUP
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
        // -------------------------------
        // SHEET PRESENTATIONS
        // -------------------------------
        .sheet(isPresented: $showAddActivityFlow) {
            AddActivityPage()
        }
        .sheet(isPresented: $showAddGroupFlow) {
            AddGroupPage()
        }
    }
}
