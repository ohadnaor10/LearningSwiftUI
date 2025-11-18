import SwiftUI

struct AddPanelView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Add new folder or activity")
                .font(.headline)

            Text("This is a placeholder. Later you will design the real builder for activity types and flows.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddPanelView()
}
