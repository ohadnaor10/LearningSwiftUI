import SwiftUI

struct TextCategoryReportPage: View {
    @Binding var category: Category
    let onNext: () -> Void

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

                    if case .textInputs(let data) = category.type {

                        ForEach(data.inputs) { input in
                            VStack(alignment: .leading, spacing: 8) {

                                Text(input.name)
                                    .font(.headline)

                                TextField("Enter text", text: binding(for: input.id))
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.12))
                                    )
                            }
                        }

                        if data.inputs.isEmpty {
                            Text("No text inputs defined.")
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
        guard case .textInputs(var data) = category.type else { return }

        for i in data.inputs.indices {
            let input = data.inputs[i]
            if let text = inputs[input.id] {
                data.inputs[i].inValue = text
            }
        }

        category.type = .textInputs(data)
        onNext()
    }
}
