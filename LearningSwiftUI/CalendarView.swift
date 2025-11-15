import SwiftUI

struct CalendarView: View {
    @Binding var currentMonth: Month
    @State private var dragOffset: CGFloat = 0
    @State private var baseOffset: CGFloat = 0
    @State private var containerWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let threshold = width * 0.33

            // update baseOffset when width changes
            Color.clear
                .onAppear {
                    containerWidth = width
                    baseOffset = -width
                    dragOffset = baseOffset
                }
                .onChange(of: width) { w in
                    containerWidth = w
                    baseOffset = -w
                    dragOffset = baseOffset
                }

            HStack(spacing: 0) {
                // previous, current, next months
                ForEach([-1, 0, 1], id: \.self) { offset in
                    let m = currentMonth.advanced(by: offset)
                    MonthGridView(month: m)
                        .frame(width: containerWidth)
                }
            }
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = baseOffset + value.translation.width
                    }
                    .onEnded { value in
                        let t = value.translation.width
                        if t <= -threshold {
                            // swipe left → next month
                            withAnimation(.easeOut(duration: 0.25)) {
                                dragOffset = -2 * containerWidth
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                currentMonth = currentMonth.next()
                                withAnimation(.none) {
                                    baseOffset = -containerWidth
                                    dragOffset = baseOffset
                                }
                            }
                        } else if t >= threshold {
                            // swipe right → previous month
                            withAnimation(.easeOut(duration: 0.25)) {
                                dragOffset = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                currentMonth = currentMonth.previous()
                                withAnimation(.none) {
                                    baseOffset = -containerWidth
                                    dragOffset = baseOffset
                                }
                            }
                        } else {
                            // not enough swipe, snap back
                            withAnimation(.easeOut) { dragOffset = baseOffset }
                        }
                    }
            ) 
        }
    }
}


