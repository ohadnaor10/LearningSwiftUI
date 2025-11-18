//
//  FlowPageRenderer.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 18/11/2025.
//

import SwiftUI

struct FlowPageRenderer: View {
    @ObservedObject var runner: FlowRunner

    @State private var textAnswers: [String: String] = [:]
    @State private var choiceAnswers: [String: String] = [:]
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let node = runner.currentNode {
                VStack(alignment: .leading, spacing: 16) {
                    if let title = node.title {
                        Text(title)
                            .font(.headline)
                    }

                    ForEach(node.questions) { q in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(q.prompt)
                                .font(.subheadline)

                            questionInput(for: q)
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }

                    Spacer()

                    Button {
                        handleNextTapped()
                    } label: {
                        Text("Next")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .onChange(of: node.id) { _ in
                    // Reset answers when node changes
                    textAnswers = [:]
                    choiceAnswers = [:]
                    errorMessage = nil
                }
            } else {
                Text("Processing...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    @ViewBuilder
    private func questionInput(for question: FlowQuestion) -> some View {
        switch question.inputKind {
        case .text:
            TextField("Enter text", text: Binding(
                get: { textAnswers[question.id] ?? "" },
                set: { textAnswers[question.id] = $0 }
            ))
            .textFieldStyle(.roundedBorder)

        case .number:
            TextField("Enter number", text: Binding(
                get: { textAnswers[question.id] ?? "" },
                set: { textAnswers[question.id] = $0 }
            ))
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)

        case .boolean:
            // For now render as text yes/no until you decide UI
            TextField("Yes or No", text: Binding(
                get: { textAnswers[question.id] ?? "" },
                set: { textAnswers[question.id] = $0 }
            ))
            .textFieldStyle(.roundedBorder)

        case .choice:
            let options = question.choices ?? []
            Menu {
                ForEach(options, id: \.self) { opt in
                    Button(opt) {
                        choiceAnswers[question.id] = opt
                    }
                }
            } label: {
                HStack {
                    Text(choiceAnswers[question.id] ?? "Choose")
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }

    private func handleNextTapped() {
        guard let node = runner.currentNode else { return }

        let result = FlowAnswerCollector.buildAnswers(
            for: node,
            textAnswers: textAnswers,
            choiceAnswers: choiceAnswers
        )

        switch result {
        case .failure(let err):
            errorMessage = err.localizedDescription

        case .success(let answers):
            errorMessage = nil
            runner.handleNext(answersByQuestionId: answers)
        }
    }
}
