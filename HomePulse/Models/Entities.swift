import Foundation
import SwiftData

enum PropertyType: String, Codable, CaseIterable, Identifiable {
    case home, rental, cabin
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}

enum TaskStatus: String, Codable, CaseIterable, Identifiable {
    case pending, dueSoon, overdue, completed
    var id: String { rawValue }
    var label: String { rawValue.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression).capitalized }
}

enum TaskCategory: String, Codable, CaseIterable, Identifiable {
    case hvac, plumbing, roof, gutters, appliances, seasonal, electrical, safety
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}

enum RepeatInterval: String, Codable, CaseIterable, Identifiable {
    case none, weekly, monthly, quarterly, biannual, yearly
    var id: String { rawValue }
}

@Model
final class Property {
    var id: UUID
    var name: String
    var type: PropertyType
    var createdAt: Date
    @Relationship(deleteRule: .cascade, inverse: \MaintenanceTask.property)
    var tasks: [MaintenanceTask]

    init(id: UUID = UUID(), name: String, type: PropertyType, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.type = type
        self.createdAt = createdAt
        self.tasks = []
    }
}

@Model
final class MaintenanceTask {
    var id: UUID
    var title: String
    var category: TaskCategory
    var dueDate: Date
    var repeatInterval: RepeatInterval
    var notes: String
    var status: TaskStatus
    var isActive: Bool
    var createdAt: Date
    var property: Property?
    @Relationship(deleteRule: .cascade, inverse: \TaskHistory.task)
    var history: [TaskHistory]

    init(id: UUID = UUID(), title: String, category: TaskCategory, dueDate: Date, repeatInterval: RepeatInterval, notes: String = "", status: TaskStatus = .pending, isActive: Bool = true, createdAt: Date = .now, property: Property? = nil) {
        self.id = id
        self.title = title
        self.category = category
        self.dueDate = dueDate
        self.repeatInterval = repeatInterval
        self.notes = notes
        self.status = status
        self.isActive = isActive
        self.createdAt = createdAt
        self.property = property
        self.history = []
    }
}

@Model
final class TaskHistory {
    var id: UUID
    var completedAt: Date
    var notes: String
    var task: MaintenanceTask?

    init(id: UUID = UUID(), completedAt: Date = .now, notes: String = "", task: MaintenanceTask? = nil) {
        self.id = id
        self.completedAt = completedAt
        self.notes = notes
        self.task = task
    }
}

@Model
final class AppPreferences {
    var id: UUID
    var hasPremium: Bool
    var activeTheme: String

    init(id: UUID = UUID(), hasPremium: Bool = false, activeTheme: String = "Sunset") {
        self.id = id
        self.hasPremium = hasPremium
        self.activeTheme = activeTheme
    }
}
