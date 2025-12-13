//
//  AppShell.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

struct AppShell: View {
    @State private var topBar: AnyView = AnyView(EmptyView())

    @State private var current = Month.current
    @State private var currentTab = 1
    
    // Controls the bottom add menu (for the Report tab)
    @State private var showAddMenu = false
    
    // NEW: back trigger for ReportPage
    @State private var reportBackTrigger = 0
    
//    @State private var triggerAddActivity = false
//    @State private var triggerAddGroup = false

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
                    onAddTapped: { showAddMenu = true },
                    showBackButton: true,                 // ← NEW
                    onBackTapped: { reportBackTrigger &+= 1 } // ← NEW
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
                    ReportPage(showAddMenu: $showAddMenu,
                               backTrigger: $reportBackTrigger     // ← NEW
                    )

                default:
                    ReportPage(showAddMenu: $showAddMenu,
                               backTrigger: $reportBackTrigger     // ← NEW
                    )
                }

                // -------------------------------
                // ADD MENU OVERLAY (Report Tab)
                // -------------------------------
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // -------------------------------
            // BOTTOM BAR
            // -------------------------------
            BottomBar(currentPage: $currentTab)
        }
    }
}

let sampleUserData: UserData = {
    let ud = UserData()
    ud.activities = [
        Activity(name: "Workout", categories: []),
        Activity(name: "Study", categories: [])
    ]
    return ud
}()


#Preview {
    let userData = UserData.loadFromDisk()
    return AppShell()
        .environmentObject(userData)
        .onChange(of: userData.activities) {
            userData.saveToDisk()
        }
        .onChange(of: userData.groups) {
            userData.saveToDisk()
        }
        .onChange(of: userData.activityInstances) {
            userData.saveToDisk()
        }
}
