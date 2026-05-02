import Foundation

@MainActor
enum PreviewFixtures {
    static func sampleProperty() -> Property {
        Property(name: "Preview Home", type: .home)
    }

    static func sampleTasks() -> [MaintenanceTask] {
        let property = sampleProperty()
        return [
            MaintenanceTask(title: "Replace HVAC filter", category: .hvac, dueDate: .now, repeatInterval: .quarterly, notes: "Preview", status: .dueSoon, property: property),
            MaintenanceTask(title: "Clean gutters", category: .gutters, dueDate: Calendar.current.date(byAdding: .day, value: -2, to: .now) ?? .now, repeatInterval: .quarterly, status: .overdue, property: property),
            MaintenanceTask(title: "Test GFCI", category: .safety, dueDate: Calendar.current.date(byAdding: .day, value: 8, to: .now) ?? .now, repeatInterval: .monthly, status: .pending, property: property)
        ]
    }
}
