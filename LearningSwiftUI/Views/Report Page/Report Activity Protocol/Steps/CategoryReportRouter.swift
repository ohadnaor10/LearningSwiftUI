import SwiftUI

struct CategoryReportRouter: View {
    @Binding var category: Category
    let onNext: () -> Void

    var body: some View {
        switch category.type {

        case .choice:
            ChoiceCategoryReportPage(
                category: $category,
                onNext: onNext
            )

        case .numberInputs:
            NumberCategoryReportPage(
                category: $category,
                onNext: onNext
            )

        case .textInputs:
            TextCategoryReportPage(
                category: $category,
                onNext: onNext
            )

        case .timeInput:
            Text("abc")
//            TimeCategoryReportPage(
//                category: $category,
//                onNext: onNext
//            )
        }
    }
}
