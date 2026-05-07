import SwiftUI

struct SetGoalCardView: View {
    let spec: SavingsGoalSpec
    let onDismiss: () -> Void

    @Environment(\.setGoal) private var setGoal
    @State private var name: String
    @State private var target: Double
    @State private var monthly: Double
    @State private var date: Date

    init(spec: SavingsGoalSpec, onDismiss: @escaping () -> Void) {
        self.spec = spec
        self.onDismiss = onDismiss
        _name = State(initialValue: spec.name)
        _target = State(initialValue: spec.targetAmount)
        _monthly = State(initialValue: spec.monthlyContribution)
        let parsed = ISO8601DateFormatter().date(from: spec.targetDateISO + "T12:00:00Z")
        _date = State(initialValue: parsed ?? Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date())
    }

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Set savings goal", systemImage: "flag.fill")
                    .font(.headline)
                row("Name") {
                    TextField("Goal name", text: $name)
                }
                row("Target") {
                    TextField("Target", value: $target, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                }
                row("Monthly") {
                    TextField("Per month", value: $monthly, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                }
                row("By") {
                    DatePicker("", selection: $date, displayedComponents: .date).labelsHidden()
                }
                HStack {
                    Button("Cancel", role: .cancel, action: onDismiss).buttonStyle(.bordered)
                    Spacer()
                    Button {
                        let goal = Goal(name: name, targetAmount: target, targetDate: date, monthlyContribution: monthly)
                        setGoal.set(goal)
                        onDismiss()
                    } label: {
                        Label("Save goal", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }

    @ViewBuilder
    private func row<Content: View>(_ label: String, @ViewBuilder _ content: () -> Content) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).font(.caption).foregroundStyle(.secondary).frame(width: 80, alignment: .leading)
            content()
            Spacer()
        }
    }
}
