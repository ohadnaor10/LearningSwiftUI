//
//  AttributeValue.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import Foundation

enum AttributeValue: Hashable {
    case text(String)
    case number(Double)
    case boolean(Bool)
    case choice(String)

    var displayString: String {
        switch self {
        case .text(let s):
            return s
        case .number(let d):
            // Simple formatting
            if d.rounded() == d {
                return String(Int(d))
            } else {
                return String(d)
            }
        case .boolean(let b):
            return b ? "Yes" : "No"
        case .choice(let c):
            return c
        }
    }
}
