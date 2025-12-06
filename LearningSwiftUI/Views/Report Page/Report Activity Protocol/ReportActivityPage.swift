import SwiftUI

struct ReportActivityPage: View {
    
    @Binding var activity: Activity
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userData: UserData
    
    enum ReportStep {
        case chooseTime
        case chooseEarlierTime
        case category(index: Int)
        case done
    }

    @State private var step: ReportStep = .chooseTime
    @State private var instance: ActivityInstance
    
    init(activity: Binding<Activity>) {
        self._activity = activity
        let initial = ActivityInstance(
            activityID: activity.wrappedValue.id,
            timestamp: Date(),
            values: [:]
        )
        self._instance = State(initialValue: initial)
    }
    var body: some View {
        VStack {
            switch step {

            case .chooseTime:
                ChooseTimePage(
                    onNow: { /* set instance.timestamp, go to first category */ },
                    onEarlier: {
                        step = .chooseEarlierTime
                    }
                )

            case .chooseEarlierTime:
                ChooseEarlierTimePage { chosen in
//                        instance.timestamp = chosen
                    goToFirstCategory()
                }


            case .category(let index):
                CategoryReportRouter(
                    category: $activity.categories[index],
                    onNext: {
                        goToNextCategory(current: index)
                    }
                )

            case .done:
                ReportDonePage(onFinish: {
                    userData.activityInstances.append(instance)
                    dismiss()
                })
            }
        }
    }

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
    
    private func saveCategoryResult(_ index: Int) {
        let cat = activity.categories[index]

        switch cat.type {

        case .choice(let data):
            let selected = data.choices.filter { $0.isOn }.map { $0.id }
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
