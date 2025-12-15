import SwiftUI

struct ReportActivityPage: View {

    @State private var activity: Activity
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userData: UserData

    enum ReportStep: Equatable {
        case chooseTime
        case chooseEarlierTime
        case category(binding: CategoryBinding)
        case done
        
        static func == (lhs: ReportStep, rhs: ReportStep) -> Bool {
            switch (lhs, rhs) {
            case (.chooseTime, .chooseTime): return true
            case (.chooseEarlierTime, .chooseEarlierTime): return true
            case (.done, .done): return true
            case (.category(let l), .category(let r)): return l.id == r.id
            default: return false
            }
        }
    }
    
    // Wrapper to make Category binding identifiable and equatable
    struct CategoryBinding: Equatable {
        let id: UUID
        let category: Category
        
        static func == (lhs: CategoryBinding, rhs: CategoryBinding) -> Bool {
            lhs.id == rhs.id
        }
    }

    @State private var step: ReportStep = .chooseTime
    @State private var lastTimeStep: ReportStep = .chooseTime
    @State private var instance: ActivityInstance
    
    // Flattened flow of all categories (main + subcategories based on selections)
    @State private var categoryFlow: [UUID] = []
    @State private var currentFlowIndex: Int = 0

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

            // Top bar
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
                            buildInitialFlow()
                            goToNextInFlow()
                        },
                        onEarlier: {
                            step = .chooseEarlierTime
                        }
                    )

                case .chooseEarlierTime:
                    ChooseEarlierTimePage { chosen in
                        instance.timestamp = chosen
                        lastTimeStep = .chooseEarlierTime
                        buildInitialFlow()
                        goToNextInFlow()
                    }

                case .category(let binding):
                    if let category = findCategory(by: binding.id) {
                        CategoryReportRouter(
                            category: Binding(
                                get: { category },
                                set: { updateCategory($0, id: binding.id) }
                            ),
                            onNext: {
                                handleCategoryCompletion(categoryID: binding.id)
                            }
                        )
                    } else {
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

    // MARK: - Flow Management
    
    private func buildInitialFlow() {
        categoryFlow = activity.categories.map { $0.id }
        currentFlowIndex = 0
    }
    
    private func handleCategoryCompletion(categoryID: UUID) {
        // Save the result first
        if let category = findCategory(by: categoryID) {
            saveCategoryResult(category)
        }
        
        // Check if we need to inject subcategories
        if let category = findCategory(by: categoryID),
           case .choice(let data) = category.type {
            
            let selectedWithChildren = data.choices.filter { $0.isOn && $0.hasChildren }
            
            if !selectedWithChildren.isEmpty {
                // Collect all subcategory IDs
                var subcatIDs: [UUID] = []
                for choice in selectedWithChildren {
                    subcatIDs.append(contentsOf: choice.subcategories.map { $0.id })
                }
                
                // Insert after current position
                let insertPosition = currentFlowIndex + 1
                categoryFlow.insert(contentsOf: subcatIDs, at: insertPosition)
            }
        }
        
        goToNextInFlow()
    }
    
    private func goToNextInFlow() {
        currentFlowIndex += 1
        
        if currentFlowIndex < categoryFlow.count {
            let catID = categoryFlow[currentFlowIndex]
            if let category = findCategory(by: catID) {
                step = .category(binding: CategoryBinding(id: catID, category: category))
            } else {
                step = .done
            }
        } else {
            step = .done
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

        case .category:
            if currentFlowIndex > 0 {
                currentFlowIndex -= 1
                let catID = categoryFlow[currentFlowIndex]
                if let category = findCategory(by: catID) {
                    step = .category(binding: CategoryBinding(id: catID, category: category))
                } else {
                    step = lastTimeStep
                }
            } else {
                step = lastTimeStep
            }

        case .done:
            if currentFlowIndex > 0 {
                currentFlowIndex = categoryFlow.count - 1
                let catID = categoryFlow[currentFlowIndex]
                if let category = findCategory(by: catID) {
                    step = .category(binding: CategoryBinding(id: catID, category: category))
                } else {
                    step = lastTimeStep
                }
            } else {
                step = lastTimeStep
            }
        }
    }

    // MARK: - Category Lookup & Update
    
    private func findCategory(by id: UUID) -> Category? {
        // Search main categories
        if let found = activity.categories.first(where: { $0.id == id }) {
            return found
        }
        
        // Search recursively in subcategories
        func searchInCategory(_ cat: Category) -> Category? {
            if cat.id == id {
                return cat
            }
            
            if case .choice(let data) = cat.type {
                for choice in data.choices where choice.hasChildren {
                    for sub in choice.subcategories {
                        if let found = searchInCategory(sub) {
                            return found
                        }
                    }
                }
            }
            
            return nil
        }
        
        for cat in activity.categories {
            if let found = searchInCategory(cat) {
                return found
            }
        }
        
        return nil
    }
    
    private func updateCategory(_ newValue: Category, id: UUID) {
        // Update in main categories
        if let index = activity.categories.firstIndex(where: { $0.id == id }) {
            activity.categories[index] = newValue
            return
        }
        
        // Update recursively in subcategories
        func updateInCategory(_ cat: inout Category) -> Bool {
            if cat.id == id {
                cat = newValue
                return true
            }
            
            if case .choice(var data) = cat.type {
                for i in data.choices.indices where data.choices[i].hasChildren {
                    for j in data.choices[i].subcategories.indices {
                        if updateInCategory(&data.choices[i].subcategories[j]) {
                            cat.type = .choice(data)
                            return true
                        }
                    }
                }
            }
            
            return false
        }
        
        for i in activity.categories.indices {
            if updateInCategory(&activity.categories[i]) {
                return
            }
        }
    }

    // MARK: - Save Results

    private func saveCategoryResult(_ category: Category) {
        switch category.type {

        case .choice(let data):
            let selected = data.choices
                .filter { $0.isOn }
                .map { $0.id }
            instance.values[category.id] = .choice(selected)

        case .numberInputs(let data):
            let dict = Dictionary(uniqueKeysWithValues:
                data.inputs.compactMap { input in
                    input.inValue.map { (input.id, $0) }
                }
            )
            instance.values[category.id] = .number(dict)

        case .textInputs(let data):
            let dict = Dictionary(uniqueKeysWithValues:
                data.inputs.compactMap { input in
                    input.inValue.map { (input.id, $0) }
                }
            )
            instance.values[category.id] = .text(dict)

        case .timeInput(let data):
            if let t = data.inValue {
                instance.values[category.id] = .time(t)
            }
        }
    }
}
