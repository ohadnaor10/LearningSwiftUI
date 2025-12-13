import SwiftUI

struct CalendarView: View {
    @Binding var currentMonth: Month
    @State private var dragOffset: CGFloat = 0
    @State private var baseOffset: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var showAddMenu: Bool = false

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let threshold = width * 0.33

            ZStack {
                // ----------------------------------------------------
                // MAIN CALENDAR CONTENT
                // ----------------------------------------------------
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
                                withAnimation(.easeOut) {
                                    dragOffset = baseOffset
                                }
                            }
                        }
                )

                // ----------------------------------------------------
                // FLOATING '+' BUTTON + MENU (BOTTOM LEFT)
                // ----------------------------------------------------
                VStack {
                    Spacer()            // push content to bottom
                    HStack(alignment: .bottom, spacing: 0) {
                        VStack(alignment: .leading, spacing: 8) {
                            if showAddMenu {
                                Button("Add Task") {
                                    // TODO: hook to your task creation
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)

                                Button("Add Event") {
                                    // TODO: hook to your event creation
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                            }

                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    showAddMenu.toggle()
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 56, height: 56)

                                    Text("+")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }

                        Spacer()    // keep it on the left side
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 20)
                }
                .ignoresSafeArea(.keyboard)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                // tap anywhere to close the menu
                if showAddMenu {
                    withAnimation {
                        showAddMenu = false
                    }
                }
            }
        }
        
        .preference(
            key: TopBarPreferenceKey.self,
            value: .calendar(
                month: currentMonth,
                isCurrent: currentMonth == .current
            )
        )
    }

}
