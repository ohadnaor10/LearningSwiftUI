//
//  BottomBar.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

struct BottomBar: View {
    @Binding var currentPage: Int

    var body: some View {
        HStack {
            barItem("Calendar", index: 0)
            barItem("Page 2", index: 1)
        }
        .frame(height: 60)
        .background(Color.gray.opacity(0.1))
    }

    private func barItem(_ title: String, index: Int) -> some View {
        Button {
            currentPage = index
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(currentPage == index ?
                    Color.blue.opacity(0.2) :
                    Color.clear)
        }
    }
}

#Preview {
    BottomBar(currentPage: .constant(0))
}
