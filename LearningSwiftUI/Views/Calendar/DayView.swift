import SwiftUI

struct DayView: View {
    let date: Date

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userData: UserData

    // Change if you want a shorter day, like 6...23
    private let hours: [Int] = Array(0...23)
    
    // Track selected instance for animation
    @State private var selectedInstance: ActivityInstance? = nil
    @Namespace private var cardAnimation

    var body: some View {
        ZStack {
            VStack(spacing: 0) {

                // ----------------------------
                // TOP BAR (in-page)
                // ----------------------------
                HStack(spacing: 12) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                    }

                    Text(dayTitle(date))
                        .font(.headline)

                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.15))

                Divider()

                // ----------------------------
                // CONTENT (hour table)
                // ----------------------------
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(hours, id: \.self) { hour in
                            DayHourRow(
                                hour: hour,
                                instances: instancesByHour[hour] ?? [],
                                activityName: activityName(for:),
                                namespace: cardAnimation,
                                selectedInstance: $selectedInstance,
                                onTap: { instance in
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedInstance = instance
                                    }
                                }
                            )

                            Divider()
                        }
                    }
                }
            }
            .opacity(selectedInstance == nil ? 1 : 0.3)
            
            // Full screen detail overlay
            if let instance = selectedInstance,
               let activity = findActivity(for: instance) {
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedInstance = nil
                        }
                    }
                
                ActivityInstanceDetailView(
                    instance: instance,
                    activity: activity
                )
                .matchedGeometryEffect(id: instance.id, in: cardAnimation)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)
                .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Data

    private var instancesByHour: [Int: [ActivityInstance]] {
        let cal = Calendar.current

        let todays = userData.activityInstances
            .filter { cal.isDate($0.timestamp, inSameDayAs: date) }

        var dict: [Int: [ActivityInstance]] = [:]
        for inst in todays {
            let h = cal.component(.hour, from: inst.timestamp)
            dict[h, default: []].append(inst)
        }

        // sort inside each hour by exact time
        for h in dict.keys {
            dict[h]?.sort { $0.timestamp < $1.timestamp }
        }

        return dict
    }

    private func activityName(for instance: ActivityInstance) -> String {
        if let a = userData.activities.first(where: { $0.id == instance.activityID }) {
            return a.name
        }
        
        // Search recursively through groups
        func findInGroup(_ group: ActivityGroup) -> Activity? {
            if let found = group.activities.first(where: { $0.id == instance.activityID }) {
                return found
            }
            for subgroup in group.subgroups {
                if let found = findInGroup(subgroup) {
                    return found
                }
            }
            return nil
        }
        
        for group in userData.groups {
            if let activity = findInGroup(group) {
                return activity.name
            }
        }
        
        return "Unknown Activity"
    }
    
    private func findActivity(for instance: ActivityInstance) -> Activity? {
        if let a = userData.activities.first(where: { $0.id == instance.activityID }) {
            return a
        }
        
        // Search recursively through groups
        func findInGroup(_ group: ActivityGroup) -> Activity? {
            if let found = group.activities.first(where: { $0.id == instance.activityID }) {
                return found
            }
            for subgroup in group.subgroups {
                if let found = findInGroup(subgroup) {
                    return found
                }
            }
            return nil
        }
        
        for group in userData.groups {
            if let activity = findInGroup(group) {
                return activity
            }
        }
        
        return nil
    }

    // MARK: - Formatting

    private func dayTitle(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = .current
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "EEEE, d MMMM yyyy"
        return df.string(from: date)
    }
}

// ------------------------------------------------------------
// Row view
// ------------------------------------------------------------

private struct DayHourRow: View {
    let hour: Int
    let instances: [ActivityInstance]
    let activityName: (ActivityInstance) -> String
    let namespace: Namespace.ID
    @Binding var selectedInstance: ActivityInstance?
    let onTap: (ActivityInstance) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // Left column: hour label
            Text(hourLabel(hour))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .trailing)
                .padding(.top, 10)

            // Right column: instances in that hour
            VStack(alignment: .leading, spacing: 8) {
                if instances.isEmpty {
                    Text("")
                        .frame(maxWidth: .infinity, minHeight: 28, alignment: .leading)
                } else {
                    ForEach(instances, id: \.id) { inst in
                        if selectedInstance?.id != inst.id {
                            Button {
                                onTap(inst)
                            } label: {
                                InstanceCard(
                                    instance: inst,
                                    activityName: activityName(inst)
                                )
                                .matchedGeometryEffect(id: inst.id, in: namespace)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .background(Color.clear)
    }

    private func hourLabel(_ h: Int) -> String {
        String(format: "%02d:00", h)
    }
}

// ------------------------------------------------------------
// Instance Card
// ------------------------------------------------------------

private struct InstanceCard: View {
    let instance: ActivityInstance
    let activityName: String
    
    var body: some View {
        HStack(spacing: 10) {
            Text(timeLabel(instance.timestamp))
                .font(.caption)
                .foregroundColor(.secondary)

            Text(activityName)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.12))
        )
    }
    
    private func timeLabel(_ d: Date) -> String {
        let df = DateFormatter()
        df.locale = .current
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "HH:mm"
        return df.string(from: d)
    }
}
