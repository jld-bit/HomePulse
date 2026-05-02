import Foundation

struct MaintenanceTemplate: Identifiable {
    let id = UUID()
    let title: String
    let category: TaskCategory
    let repeatInterval: RepeatInterval
    let note: String
    let dueOffsetDays: Int

    func makeTask(property: Property) -> MaintenanceTask {
        MaintenanceTask(
            title: title,
            category: category,
            dueDate: Calendar.current.date(byAdding: .day, value: dueOffsetDays, to: .now) ?? .now,
            repeatInterval: repeatInterval,
            notes: note,
            status: .pending,
            property: property
        )
    }

    static let defaults: [MaintenanceTemplate] = [
        .init(title: "Swap HVAC filter", category: .hvac, repeatInterval: .quarterly, note: "Use MERV-8 or higher.", dueOffsetDays: 5),
        .init(title: "Check water heater valve", category: .plumbing, repeatInterval: .biannual, note: "Inspect for leaks and corrosion.", dueOffsetDays: 15),
        .init(title: "Inspect roof shingles", category: .roof, repeatInterval: .yearly, note: "Look for curling or missing shingles.", dueOffsetDays: 25),
        .init(title: "Clear gutters", category: .gutters, repeatInterval: .quarterly, note: "Remove leaves and verify downspout flow.", dueOffsetDays: 7),
        .init(title: "Clean refrigerator coils", category: .appliances, repeatInterval: .biannual, note: "Vacuum condenser coils.", dueOffsetDays: 12),
        .init(title: "Winterize exterior faucets", category: .seasonal, repeatInterval: .yearly, note: "Disconnect hoses before freeze.", dueOffsetDays: 40)
    ]
}
