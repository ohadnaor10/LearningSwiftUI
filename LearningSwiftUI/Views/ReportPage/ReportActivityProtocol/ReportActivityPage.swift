//
//  ReportActivityPage.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 06/12/2025.
//

import SwiftUI

struct ReportActivityPage: View {
    
    @Binding var activity: Activity
    @Environment(\.dismiss) private var dismiss
    
    enum ReportStep {
        case chooseTime
        case chooseEarlierTime
        case category(index: Int)
        case done
    }

    @State private var step: ReportStep = .chooseTime
    
    var body: some View {
//            VStack {
//                switch step {
//
//                case .chooseTime:
//                    ChooseTimePage(
//                        onNow: {
//                            activity.reportedTime = Date()      // if you store this
//                            goToFirstCategory()
//                        },
//                        onEarlier: {
//                            step = .chooseEarlierTime
//                        }
//                    )
//
//                case .chooseEarlierTime:
//                    ChooseEarlierTimePage(onDone: { selectedDate in
//                        activity.reportedTime = selectedDate
//                        goToFirstCategory()
//                    })
//
//                case .category(let index):
//                    CategoryReportRouter(
//                        category: $activity.categories[index],
//                        onNext: {
//                            goToNextCategory(current: index)
//                        }
//                    )
//
//                case .done:
//                    ReportDonePage(onFinish: {
//                        dismiss()
//                    })
//                }
//            }
//        }
//
//        private func goToFirstCategory() {
//            if activity.categories.isEmpty {
//                step = .done
//            } else {
//                step = .category(0)
//            }
//        }
//
//        private func goToNextCategory(current index: Int) {
//            if index + 1 < activity.categories.count {
//                step = .category(index + 1)
//            } else {
//                step = .done
//            }
        }
    }
