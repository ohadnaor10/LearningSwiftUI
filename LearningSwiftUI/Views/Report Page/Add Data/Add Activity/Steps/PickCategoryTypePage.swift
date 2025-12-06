import SwiftUI

struct PickCategoryTypePage: View {

    var onPick: (CategoryType) -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            // Title
            Text("Choose Category Type")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 32)

            Spacer()

            // CATEGORY TYPE BUTTONS
            VStack(spacing: 16) {

                typeButton("Choice") {
                    onPick(.choice(ChoiceData(choices: [])))
                }

                typeButton("Number Inputs") {
                    onPick(.numberInputs(NumberInputsData(inputs: [])))
                }

                typeButton("Text Inputs") {
                    onPick(.textInputs(TextInputsData(inputs: [])))
                }

                typeButton("Time Input") {
                    onPick(.timeInput(TimeInputData(name: "Time")))
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Cancel
            Button(action: onCancel) {
                Text("Cancel")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }

    private func typeButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
}
