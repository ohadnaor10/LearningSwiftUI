//
//  AddCategoryPage.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 29/11/2025.
//

import Foundation
import SwiftUI



struct AddCategoryTopBar: View {
    let activityName: String

    var body: some View {
        ZStack {
            Color.gray.opacity(0.15)

            Text("Add Categories to '\(activityName)'")
                .font(.headline)
                .padding(.vertical, 12)
        }
        .frame(height: 60)
    }
}


