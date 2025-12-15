import SwiftUI

struct ActivityInstanceDetailView: View {
    let instance: ActivityInstance
    let activity: Activity
    
    @Environment(\.dismiss) private var dismiss
    @Namespace private var animation
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(activity.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(formatTimestamp(instance.timestamp))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 24)
                
                Divider()
                
                // Category Values
                ForEach(activity.categories, id: \.id) { category in
                    if let value = instance.values[category.id] {
                        CategoryValueSection(
                            category: category,
                            value: value
                        )
                        .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 24)
            }
        }
        .background(Color(.systemBackground))
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.gray)
                    .padding(16)
            }
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Category Value Section

struct CategoryValueSection: View {
    let category: Category
    let value: CategoryValue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(category.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            switch (category.type, value) {
            case (.choice(let data), .choice(let selectedIDs)):
                ChoiceValueView(choices: data.choices, selectedIDs: selectedIDs)
                
            case (.numberInputs(let data), .number(let values)):
                NumberValuesView(inputs: data.inputs, values: values)
                
            case (.textInputs(let data), .text(let values)):
                TextValuesView(inputs: data.inputs, values: values)
                
            case (.timeInput(let data), .time(let timeValue)):
                TimeValueView(name: data.name, time: timeValue)
                
            default:
                Text("Invalid data")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.08))
        )
    }
}

// MARK: - Value Type Views

struct ChoiceValueView: View {
    let choices: [Choice]
    let selectedIDs: [UUID]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(choices.filter { selectedIDs.contains($0.id) }) { choice in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                    Text(choice.name)
                        .font(.body)
                }
            }
            
            if selectedIDs.isEmpty {
                Text("No selection")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}

struct NumberValuesView: View {
    let inputs: [NumberInput]
    let values: [UUID: Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(inputs) { input in
                if let value = values[input.id] {
                    HStack {
                        Text(input.name)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(value)")
                            .font(.body)
                            .fontWeight(.medium)
                    }
                }
            }
            
            if values.isEmpty {
                Text("No values entered")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}

struct TextValuesView: View {
    let inputs: [TextInput]
    let values: [UUID: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(inputs) { input in
                if let value = values[input.id], !value.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(input.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(value)
                            .font(.body)
                    }
                }
            }
            
            if values.isEmpty {
                Text("No text entered")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}

struct TimeValueView: View {
    let name: String
    let time: Date
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(.secondary)
            Spacer()
            Text(formatTime(time))
                .font(.body)
                .fontWeight(.medium)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
