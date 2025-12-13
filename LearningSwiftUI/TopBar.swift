
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


struct TopBarPreferenceKey: PreferenceKey {
    static var defaultValue: AnyView? = nil
    static func reduce(value: inout AnyView?, nextValue: () -> AnyView?) {
        value = nextValue() ?? value
    }
}
