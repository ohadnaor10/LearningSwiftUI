//
//  CalendarView.swift
//  LearningSwiftUI
//
//  Created by Ohad Naor on 13/11/2025.
//

import SwiftUI

struct CalendarView: View {
    @Binding var currentMonth: Month
    @State private var page: Int = 0            // -1, 0, +1 window

    private var window: [Int] { [-1, 0, 1] }    // three pages only

    var body: some View {
        TabView(selection: $page) {
            ForEach(window, id: \.self) { offset in
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    let r: CGFloat = 0.15
                    let mainRow = h / (6 + r)
                    let firstRow = r * mainRow
                    let colW = w / 7

                    // draw the grid for currentMonth.advanced(by: offset)
                    Canvas { context, size in
                        var path = Path()
                        // verticals, start halfway down first row
                        for col in 1..<7 {
                            let x = colW * CGFloat(col)
                            path.move(to: CGPoint(x: x, y: firstRow / 2))
                            path.addLine(to: CGPoint(x: x, y: size.height))
                        }
                        // horizontals between rows, no outer strokes
                        var y = firstRow
                        for _ in 1..<7 {
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: size.width, y: y))
                            y += mainRow
                        }
                        context.stroke(path, with: .color(.black), lineWidth: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .tag(offset)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: page) { newValue in
            if newValue == 1 {
                currentMonth = currentMonth.next()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    page = 0
                }
            } else if newValue == -1 {
                currentMonth = currentMonth.previous()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    page = 0
                }
            }
        }

        .animation(.easeInOut, value: page)
    }
}
