import SwiftUI

struct AttributeCardView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}
