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


struct TopBarGenericReportPage: View {
    var title: String
    var showAddButton: Bool = false
    var onAddTapped: () -> Void = {}

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.leading, 12)

            Spacer()

            if showAddButton {
                Button(action: onAddTapped) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                }
                .padding(.trailing, 12)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.15))
    }
}
