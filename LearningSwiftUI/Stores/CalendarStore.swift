//
//  CalendarStore.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 17/11/2025.
//

import Foundation
import SwiftUI

final class CalendarStore: ObservableObject {
    @Published private(set) var days: [DayKey: DayData] = [:]
}
