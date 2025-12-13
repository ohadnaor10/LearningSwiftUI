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
            
            // These are allowed here
            let lastMonth = month.previous()
            let nextMonth = month.next()
            
            let w = geo.size.width
            let h = geo.size.height
            let r: CGFloat = 0.15
            let mainRow = h / (6 + r)
            let firstRow = r * mainRow
            let colW = w / 7

            let start = month.firstWeekdayIndexSunday0   // 0–6
            let days = month.numberOfDays
            let weekdays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]

            ZStack {
                // Grid lines
                Canvas { ctx, size in
                    var path = Path()
                    // verticals
                    for col in 1..<7 {
                        let x = colW * CGFloat(col)
                        path.move(to: CGPoint(x: x, y: firstRow / 2))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                        // edge verticals
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

                // Weekday headers and days
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 0) {
                        ForEach(0..<7) { i in
                            Text(weekdays[i])
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: colW, height: firstRow)
                        }
                    }
                    
                    // 6 rows of days
                    ForEach(0..<6) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<7) { col in
                                let idx = row * 7 + col
                                let day = idx - start + 1
                                // choose a fixed ratio for the day-number bar
                                let dayTopBar = mainRow * 0.24   // ~24% of the cell height
                                // compute "today" once per grid
                                let now = Date()
                                let nowComps = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: now)
                                let isThisMonth = (nowComps.year == month.year && nowComps.month == month.month)
                                let today = nowComps.day ?? -1
                                
                                let pastMonthLastDay = lastMonth.numberOfDays
                                let pastMonthDay = pastMonthLastDay - (start - idx) + 1
                                let nextMonthDay = idx - (start + days) + 1
                                
                                let displayMonth: Month =
                                    (day >= 1 && day <= days) ? month :
                                    (day < 1) ? lastMonth :
                                               nextMonth

                                let displayDay: Int =
                                    (day >= 1 && day <= days) ? day :
                                    (day < 1) ? pastMonthDay :
                                               nextMonthDay

                                let cellDate = displayMonth.date(forDay: displayDay)

                                let instanceIDsForDay: [UUID] = {
                                    guard let d = cellDate else { return [] }
                                    let cal = Calendar(identifier: .gregorian)
                                    return userData.activityInstances
                                        .filter { cal.isDate($0.timestamp, inSameDayAs: d) }
                                        .map { $0.id }
                                }()

                                VStack(spacing: 0) {
                                    // Top bar: day number pinned top-left
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

                                        } else if day < 1 {
                                            Text("\(pastMonthDay)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(.top, 5)
                                        }
                                    }
                                    .frame(width: colW, height: dayTopBar)

                                    // Content area: tasks go here later
                                    ZStack {
                                        Color.clear

                                        if !instanceIDsForDay.isEmpty {
                                            Circle()
                                                .frame(width: 6, height: 6)
                                                .padding(.top, 6)
                                        }
                                    }
                                    .frame(width: colW, height: mainRow - dayTopBar)
                                }
                                .frame(width: colW, height: mainRow)

                            }
                        }
                    }
                }
                .frame(width: w, height: h, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
