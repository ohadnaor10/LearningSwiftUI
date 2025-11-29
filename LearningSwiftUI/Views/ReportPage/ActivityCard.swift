import SwiftUI

/// A small rounded square card representing an Activity in the ReportPage.
/// This is purely UI. It does not run the activity or manage data.
struct ActivityCard: View {
    let activity: Activity
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack {
                Text(activity.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding([.horizontal], 4)
            }
            .frame(width: 110, height: 110)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.15))
            )
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    let sampleCategory = Category(
//        name: "Root",
//        type: .textInputs(TextInputsData(inputs: []))
//    )
//    let sampleActivity = Activity(name: "Sample", startingCategory: sampleCategory)
//
//    return ActivityCard(activity: sampleActivity) {
//        print("Tapped!")
//    }
//}
