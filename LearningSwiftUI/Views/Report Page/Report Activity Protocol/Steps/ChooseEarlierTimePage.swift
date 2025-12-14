import SwiftUI

struct ChooseEarlierTimePage: View {
    let onDone: (Date) -> Void

    @State private var selectedDate: Date = Date()

    // Helpers to limit picker to "today"
    private var todayStart: Date {
        Calendar.current.startOfDay(for: Date())
    }

    private var todayEnd: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
    }

    var body: some View {
        VStack(spacing: 24) {

            Text("When earlier today?")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 32)

            Text("Pick the approximate time you did this activity.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            DatePicker(
                "Time",
                selection: $selectedDate,
                in: todayStart...todayEnd,
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                onDone(selectedDate)
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
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
