//
//  AddActivityButtons.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 29/11/2025.
//

import Foundation
import SwiftUI

struct AddCategoryButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Category")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct CompleteActivityButton: View {
    var title: String = "Complete Activity"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
}

struct AddAttributeButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Attribute")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct CompleteCategoryButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Complete Category")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
}
