//
//  AppShell.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//
import SwiftUI

struct AppShell: View {
    @State private var current = Month.current

    var body: some View {
        VStack(spacing: 0) {
            TopBar(month: current)

            CalendarView(currentMonth: $current)   // updates on swipe

            BottomBar(currentPage: .constant(0)) // unchanged for now
        }
    }
}


#Preview {
    AppShell()
}
