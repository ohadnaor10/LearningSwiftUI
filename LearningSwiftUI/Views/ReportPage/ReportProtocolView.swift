import SwiftUI

struct ReportProtocolView: View {
    let activityType: ActivityType

    @Environment(\.dismiss) private var dismiss
    @StateObject private var runner: FlowRunner

    init(activityType: ActivityType) {
        self.activityType = activityType
        _runner = StateObject(wrappedValue: FlowRunner(activityType: activityType))
    }

    var body: some View {
        NavigationStack {
            Group {
                if let instance = runner.finishedInstance {
                    summaryView(instance: instance)
                } else {
                    FlowPageRenderer(runner: runner)
                }
            }
            .navigationTitle(activityType.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            runner.start()
        }
    }

    private func summaryView(instance: ActivityInstance) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Report saved")
                .font(.headline)

            Text("Activity: \(activityType.icon) \(activityType.name)")
            Text("Time: \(instance.timestamp.formatted(date: .omitted, time: .shortened))")

            Divider()

            if instance.values.isEmpty {
                Text("No values recorded.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(Array(instance.values.keys.sorted()), id: \.self) { key in
                    if let def = activityType.attributes[key],
                       let value = instance.values[key] {
                        HStack {
                            Text(def.displayName + ":")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(value.displayString)
                        }
                    }
                }
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ReportProtocolView(activityType: .drinkWater)
}
