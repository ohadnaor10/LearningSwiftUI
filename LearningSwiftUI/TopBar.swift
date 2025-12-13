
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


import SwiftUI

enum TopBarConfig: Equatable {
    case calendar(month: Month, isCurrent: Bool)
    case report(title: String, showAdd: Bool, showBack: Bool)
    case empty
}

struct TopBarPreferenceKey: PreferenceKey {
    static var defaultValue: TopBarConfig = .empty
    static func reduce(value: inout TopBarConfig, nextValue: () -> TopBarConfig) {
        value = nextValue()
    }
}
