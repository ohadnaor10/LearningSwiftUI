import SwiftUI

struct ReportDonePage: View {
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundColor(.green)

            Text("Report saved")
                .font(.title2)
                .fontWeight(.semibold)

            Text("This activity has been logged.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Button(action: onFinish) {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
    }
}
