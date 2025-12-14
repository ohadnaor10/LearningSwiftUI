import SwiftUI

struct ChoiceCategoryReportPage: View {
    @Binding var category: Category
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            Text(category.name)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 24)

            Spacer()

            ScrollView {
                VStack(spacing: 12) {
                    if case .choice(let data) = category.type {
                        ForEach(Array(data.choices.enumerated()), id: \.element.id) { index, choice in
                            
                            Button(action: {
                                toggleChoice(at: index)
                            }) {
                                HStack {
                                    Text(choice.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: choice.isOn ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(choice.isOn ? .blue : .gray.opacity(0.5))
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.12))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    } else {
                        Text("Invalid category type.")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 24)
            }

            Spacer()

            Button(action: onNext) {
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

    private func toggleChoice(at index: Int) {
        guard case .choice(var data) = category.type else { return }
        guard data.choices.indices.contains(index) else { return }

        data.choices[index].isOn.toggle()
        
        category.type = .choice(data)
    }
}
