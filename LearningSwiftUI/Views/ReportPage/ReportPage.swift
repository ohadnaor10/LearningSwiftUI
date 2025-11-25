import SwiftUI

struct ReportPage: View {

//    @State private var rootGroup: ActivityGroup
//    @State private var currentGroup: ActivityGroup
    @Binding var showAddMenu: Bool
    @State private var showAddActivityFlow = false
    @State private var showAddGroupFlow = false
    @EnvironmentObject var groupsStore: GroupsStore


    var body: some View {
        ContentPage()
        
        if showAddMenu {
            // Dim background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showAddMenu = false
                    }
                }

            // Sliding menu
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    Button("Add Activity") {
                        print("Add Activity tapped")
                        withAnimation { showAddMenu = false }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                showAddActivityFlow = true
                        }
                    }
                    .font(.headline)

                    Button("Add Group") {
                        print("Add Group tapped")
                        withAnimation { showAddMenu = false }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
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
            .sheet(isPresented: $showAddActivityFlow) {
                AddActivityPage()
            }

            .sheet(isPresented: $showAddGroupFlow) {
                AddGroupPage()
            }
        }

    }
}


