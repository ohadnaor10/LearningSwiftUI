//
//  AppShell.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

struct AppShell: View {
    @State private var current = Month.current
    @State private var currentTab = 0

    // Controls the bottom add menu (for the Report tab)
    @State private var showAddMenu = false

    var body: some View {
        VStack(spacing: 0) {

            // -------------------------------
            // TOP BAR
            // -------------------------------
            if currentTab == 0 {
                TopBar(month: current, isCurrentMonth: current == .current)

            } else if currentTab == 1 {
                TopBarGenericReportPage(
                    title: "Report Your Activities",
                    showAddButton: true,
                    onAddTapped: { showAddMenu = true }
                )

            } else {
                TopBarGeneric(title: "")
            }

            // -------------------------------
            // MAIN CONTENT
            // -------------------------------
            ZStack {

                switch currentTab {
                case 0:
                    CalendarView(currentMonth: $current)

                case 1:
                    ReportPage()

                default:
                    CalendarView(currentMonth: $current)
                }

                // -------------------------------
                // ADD MENU OVERLAY (Report Tab)
                // -------------------------------
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
                            }
                            .font(.headline)

                            Button("Add Group") {
                                print("Add Group tapped")
                                withAnimation { showAddMenu = false }
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // -------------------------------
            // BOTTOM BAR
            // -------------------------------
            BottomBar(currentPage: $currentTab)
        }
    }
}

#Preview {
    AppShell()
}
