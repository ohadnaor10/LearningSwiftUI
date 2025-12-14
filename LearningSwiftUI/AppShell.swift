import SwiftUI

struct AppShell: View {
    @State private var topBarConfig: TopBarConfig = .empty

    @State private var current = Month.current
    @State private var currentTab = 1

    // Controls the bottom add menu (for the Report tab)
    @State private var showAddMenu = false

    // Back trigger for ReportPage
    @State private var reportBackTrigger = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // -------------------------------
                // TOP BAR
                // -------------------------------
                switch topBarConfig {
                case .calendar(let month, let isCurrent):
                    TopBar(month: month, isCurrentMonth: isCurrent)
                    
                case .report(let title, let showAdd, let showBack):
                    TopBarGenericReportPage(
                        title: title,
                        showAddButton: showAdd,
                        onAddTapped: { showAddMenu = true },
                        showBackButton: showBack,
                        onBackTapped: { reportBackTrigger &+= 1 }
                    )
                    
                case .empty:
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
                        ReportPage(
                            showAddMenu: $showAddMenu,
                            backTrigger: $reportBackTrigger
                        )
                        
                    default:
                        ReportPage(
                            showAddMenu: $showAddMenu,
                            backTrigger: $reportBackTrigger
                        )
                    }
                }
                .onPreferenceChange(TopBarPreferenceKey.self) { newConfig in
                    topBarConfig = newConfig
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // -------------------------------
                // BOTTOM BAR
                // -------------------------------
                BottomBar(currentPage: $currentTab)
            }
        }
    }
}

#Preview {
    let userData = UserData.loadFromDisk()

    return AppShell()
        .environmentObject(userData)
        .onChange(of: userData.activities) { _, _ in
            userData.saveToDisk()
        }
        .onChange(of: userData.groups) { _, _ in
            userData.saveToDisk()
        }
        .onChange(of: userData.activityInstances) { _, _ in
            userData.saveToDisk()
        }
}
