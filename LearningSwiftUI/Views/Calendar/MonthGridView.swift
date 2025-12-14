//
//  MonthGridView.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 15/11/2025.
//

import SwiftUI

struct MonthGridView: View {
    let month: Month

    @EnvironmentObject var userData: UserData

    var body: some View {
        GeometryReader { geo in

            let lastMonth = month.previous()
            let nextMonth = month.next()

            let w = geo.size.width
            let h = geo.size.height
            let r: CGFloat = 0.15
            let mainRow = h / (6 + r)
            let firstRow = r * mainRow
            let colW = w / 7

            let start = month.firstWeekdayIndexSunday0
            let days = month.numberOfDays
            let weekdays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]

            // "today"
            let now = Date()
            let cal = Calendar(identifier: .gregorian)
            let nowComps = cal.dateComponents([.year, .month, .day], from: now)
            let isThisMonth = (nowComps.year == month.year && nowComps.month == month.month)
            let today = nowComps.day ?? -1

            ZStack {
                // Grid lines
                Canvas { ctx, size in
                    var path = Path()

                    // verticals
                    for col in 1..<7 {
                        let x = colW * CGFloat(col)
                        path.move(to: CGPoint(x: x, y: firstRow / 2))
                        path.addLine(to: CGPoint(x: x, y: size.height))

                        path.move(to: CGPoint(x: 0.5, y: firstRow / 2))
                        path.addLine(to: CGPoint(x: 0.5, y: size.height))

                        path.move(to: CGPoint(x: size.width - 0.5, y: firstRow / 2))
                        path.addLine(to: CGPoint(x: size.width - 0.5, y: size.height))
                    }

                    // horizontals
                    var y = firstRow
                    for _ in 1..<7 {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        y += mainRow
                    }

                    ctx.stroke(path, with: .color(.black), lineWidth: 1)
                }

                VStack(spacing: 0) {

                    // Header
                    HStack(spacing: 0) {
                        ForEach(0..<7, id: \.self) { i in
                            Text(weekdays[i])
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: colW, height: firstRow)
                        }
                    }

                    // 6 rows
                    ForEach(0..<6, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<7, id: \.self) { col in
                                let idx = row * 7 + col
                                let day = idx - start + 1

                                let dayTopBar = mainRow * 0.24

                                let pastMonthLastDay = lastMonth.numberOfDays
                                let pastMonthDay = pastMonthLastDay - (start - idx) + 1
                                let nextMonthDay = idx - (start + days) + 1

                                let cellDate: Date? = {
                                    var cal = Calendar(identifier: .gregorian)
                                    cal.firstWeekday = 1

                                    if day >= 1 && day <= days {
                                        return cal.date(from: DateComponents(year: month.year, month: month.month, day: day))
                                    } else if day < 1 {
                                        return cal.date(from: DateComponents(year: lastMonth.year, month: lastMonth.month, day: pastMonthDay))
                                    } else {
                                        return cal.date(from: DateComponents(year: nextMonth.year, month: nextMonth.month, day: nextMonthDay))
                                    }
                                }()

                                // IMPORTANT: compute before using it in the view
                                let instanceIDsForDay: [UUID] = {
                                    guard let d = cellDate else { return [] }
                                    let cal = Calendar(identifier: .gregorian)
                                    return userData.activityInstances
                                        .filter { cal.isDate($0.timestamp, inSameDayAs: d) }
                                        .map { $0.id }
                                }()
                                
                                let instanceCountForDay = instanceIDsForDay.count

                                Group {
                                    if let cellDate {
                                        NavigationLink {
                                            DayView(date: cellDate)
                                        } label: {
                                            dayCellView(
                                                day: day,
                                                days: days,
                                                pastMonthDay: pastMonthDay,
                                                nextMonthDay: nextMonthDay,
                                                isThisMonth: isThisMonth,
                                                today: today,
                                                colW: colW,
                                                mainRow: mainRow,
                                                dayTopBar: dayTopBar,
                                                hasInstances: !instanceIDsForDay.isEmpty,
                                                instanceCount: instanceCountForDay,
                                                instanceIDs: instanceIDsForDay
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    } else {
                                        dayCellView(
                                            day: day,
                                            days: days,
                                            pastMonthDay: pastMonthDay,
                                            nextMonthDay: nextMonthDay,
                                            isThisMonth: isThisMonth,
                                            today: today,
                                            colW: colW,
                                            mainRow: mainRow,
                                            dayTopBar: dayTopBar,
                                            hasInstances: !instanceIDsForDay.isEmpty,
                                            instanceCount: instanceCountForDay,
                                            instanceIDs: instanceIDsForDay
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: w, height: h, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @ViewBuilder
    private func dayCellView(
        day: Int,
        days: Int,
        pastMonthDay: Int,
        nextMonthDay: Int,
        isThisMonth: Bool,
        today: Int,
        colW: CGFloat,
        mainRow: CGFloat,
        dayTopBar: CGFloat,
        hasInstances: Bool,
        instanceCount: Int,
        instanceIDs: [UUID]
        
    ) -> some View {

        VStack(spacing: 0) {
            // Top bar: day number
            ZStack(alignment: .top) {
                Color.clear

                if day >= 1 && day <= days {
                    Text("\(day)")
                        .font(.caption)
                        .foregroundColor(isThisMonth && day == today ? .blue : .primary)
                        .padding(.top, 5)
                } else if day > days {
                    Text("\(nextMonthDay)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                } else {
                    Text("\(pastMonthDay)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                }
            }
            .frame(width: colW, height: dayTopBar)

            // Content area (dot marker)
            ZStack {
                Color.clear

                if instanceCount > 0 {
                    Text("\(instanceCount)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Circle().fill(Color.blue))
                        .padding(.top, 4)
                }
            }
            .frame(width: colW, height: mainRow - dayTopBar)
        }
        .frame(width: colW, height: mainRow)
        .contentShape(Rectangle())
    }
}
