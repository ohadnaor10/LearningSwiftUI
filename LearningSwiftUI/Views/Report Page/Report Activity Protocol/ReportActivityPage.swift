import SwiftUI

struct ReportActivityPage: View {

    // We keep a local copy so the flow is stable (and we don’t depend on a Binding existing immediately).
    @State private var activity: Activity
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userData: UserData

    enum ReportStep: Equatable {
        case chooseTime
        case chooseEarlierTime
        case category(index: Int)
        case done
    }

    @State private var step: ReportStep = .chooseTime

    // Remember which time screen we came from, so “Back” from the first category returns correctly.
    @State private var lastTimeStep: ReportStep = .chooseTime

    @State private var instance: ActivityInstance

    // MARK: - Init

    init(activity: Activity) {
        _activity = State(initialValue: activity)

        let initial = ActivityInstance(
            activityID: activity.id,
            timestamp: Date(),
            values: [:]
        )
        _instance = State(initialValue: initial)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // Top bar inside the sheet
            HStack {
                Button {
                    goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                }
                .opacity(canGoBack ? 1 : 0)
                .disabled(!canGoBack)

                Spacer()

                Text(activity.name)
                    .font(.headline)

                Spacer()

                // keeps title centered
                Color.clear.frame(width: 24, height: 24)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.15))

            // Flow content
            VStack {
                switch step {

                case .chooseTime:
                    ChooseTimePage(
                        onNow: {
                            instance.timestamp = Date()
                            lastTimeStep = .chooseTime
                            goToFirstCategory()
                        },
                        onEarlier: {
                            step = .chooseEarlierTime
                        }
                    )

                case .chooseEarlierTime:
                    ChooseEarlierTimePage { chosen in
                        instance.timestamp = chosen
                        lastTimeStep = .chooseEarlierTime
                        goToFirstCategory()
                    }

                case .category(let index):
                    if activity.categories.indices.contains(index) {
                        CategoryReportRouter(
                            category: $activity.categories[index],
                            onNext: { goToNextCategory(current: index) }
                        )
                    } else {
                        // Safety fallback
                        Color.clear.onAppear { step = .done }
                    }

                case .done:
                    ReportDonePage(onFinish: {
                        userData.activityInstances.append(instance)
                        dismiss()
                    })
                }
            }
        }
    }

    // MARK: - Back logic

    private var canGoBack: Bool {
        switch step {
        case .chooseTime:
            return false
        default:
            return true
        }
    }

    private func goBack() {
        switch step {

        case .chooseTime:
            return

        case .chooseEarlierTime:
            step = .chooseTime

        case .category(let index):
            if index > 0 {
                step = .category(index: index - 1)
            } else {
                // Back from first category goes to the last time screen used
                step = lastTimeStep
            }

        case .done:
            if activity.categories.isEmpty {
                step = lastTimeStep
            } else {
                step = .category(index: max(activity.categories.count - 1, 0))
            }
        }
    }

    // MARK: - Step helpers

    private func goToFirstCategory() {
        if activity.categories.isEmpty {
            step = .done
        } else {
            step = .category(index: 0)
        }
    }

    private func goToNextCategory(current index: Int) {
        saveCategoryResult(index)

        if index + 1 < activity.categories.count {
            step = .category(index: index + 1)
        } else {
            step = .done
        }
    }

    // MARK: - Store answers into instance

    private func saveCategoryResult(_ index: Int) {
        guard activity.categories.indices.contains(index) else { return }
        let cat = activity.categories[index]

        switch cat.type {

        case .choice(let data):
            let selected = data.choices
                .filter { $0.isOn }
                .map { $0.id }
            instance.values[cat.id] = .choice(selected)

        case .numberInputs(let data):
            let dict = Dictionary(uniqueKeysWithValues:
                data.inputs.compactMap { input in
                    input.inValue.map { (input.id, $0) }
                }
            )
            instance.values[cat.id] = .number(dict)

        case .textInputs(let data):
            let dict = Dictionary(uniqueKeysWithValues:
                data.inputs.compactMap { input in
                    input.inValue.map { (input.id, $0) }
                }
            )
            instance.values[cat.id] = .text(dict)

        case .timeInput(let data):
            if let t = data.inValue {
                instance.values[cat.id] = .time(t)
            }
        }
    }
}
