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

    var body: some View {
        VStack(spacing: 0) {
            if currentTab == 0 {
                TopBar(month: current, isCurrentMonth: current == .current)
            } else {
                TopBarGeneric(title: "Page 2")
            }



            Group {
                switch currentTab {
                case 0:
                    CalendarView(currentMonth: $current)
                case 1:
                    Page2()
                default:
                    CalendarView(currentMonth: $current)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            BottomBar(currentPage: $currentTab)
        }
    }
}



#Preview {
    AppShell()
}
