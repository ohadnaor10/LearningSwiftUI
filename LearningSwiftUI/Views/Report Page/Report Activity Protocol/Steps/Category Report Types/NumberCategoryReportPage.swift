import SwiftUI

struct NumberCategoryReportPage: View {
    @Binding var category: Category
    let onNext: () -> Void

    // Local copy so user can type freely
    @State private var inputs: [UUID: String] = [:]

    var body: some View {
        VStack(spacing: 24) {

            Text(category.name)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 24)

            Spacer()

            ScrollView {
                VStack(spacing: 16) {

                    if case .numberInputs(let data) = category.type {

                        ForEach(data.inputs) { input in
                            VStack(alignment: .leading, spacing: 8) {

                                Text(input.name)
                                    .font(.headline)

                                TextField("Enter a number", text: binding(for: input.id))
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.12))
                                    )
                            }
                        }

                        if data.inputs.isEmpty {
                            Text("No number fields defined.")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }

                    } else {
                        Text("Invalid category type.")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 24)
            }

            Spacer()

            Button(action: saveAndContinue) {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
            }
            .padding(.bottom, 24)
        }
    }

    // MARK: - Helpers

    private func binding(for id: UUID) -> Binding<String> {
        Binding(
            get: { inputs[id] ?? "" },
            set: { inputs[id] = $0 }
        )
    }

    private func saveAndContinue() {
        guard case .numberInputs(var data) = category.type else { return }

        for i in data.inputs.indices {
            let input = data.inputs[i]
            if let text = inputs[input.id], let number = Int(text) {
                data.inputs[i].inValue = number
            }
        }

        category.type = .numberInputs(data)
        onNext()
    }
}
