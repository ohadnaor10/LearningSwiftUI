//
//  TopBar.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

struct TopBar: View {
    let month: Month
    let isCurrentMonth: Bool

    var body: some View {
        ZStack {
            Color.gray.opacity(0.15)
            Text(month.title)
                .font(.headline)
                .foregroundColor(isCurrentMonth ? .blue : .primary)
        }
        .frame(height: 60)
    }
}


struct TopBarGeneric: View {
    let title: String

    var body: some View {
        ZStack {
            Color.gray.opacity(0.15)
            Text(title)
                .font(.headline)
        }
        .frame(height: 60)
    }
}
