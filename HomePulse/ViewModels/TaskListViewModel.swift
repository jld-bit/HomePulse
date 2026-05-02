import Foundation
import SwiftData

@MainActor
final class TaskListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCategory: TaskCategory?
    @Published var selectedStatus: TaskStatus?
    @Published var selectedPropertyID: UUID?

    func filteredTasks(_ tasks: [MaintenanceTask]) -> [MaintenanceTask] {
        tasks.filter { task in
            let searchMatch = searchText.isEmpty || task.title.localizedCaseInsensitiveContains(searchText)
            let categoryMatch = selectedCategory == nil || task.category == selectedCategory
            let statusMatch = selectedStatus == nil || task.status == selectedStatus
            let propertyMatch = selectedPropertyID == nil || task.property?.id == selectedPropertyID
            return searchMatch && categoryMatch && statusMatch && propertyMatch
        }
    }

    func markCompleted(_ task: MaintenanceTask, context: ModelContext) {
        task.status = .completed
        task.isActive = false
        task.history.append(TaskHistory(completedAt: .now, notes: "Marked complete in app", task: task))
        task.dueDate = nextDueDate(for: task)
        try? context.save()
    }

    private func nextDueDate(for task: MaintenanceTask) -> Date {
        switch task.repeatInterval {
        case .weekly: return Calendar.current.date(byAdding: .day, value: 7, to: task.dueDate) ?? task.dueDate
        case .monthly: return Calendar.current.date(byAdding: .month, value: 1, to: task.dueDate) ?? task.dueDate
        case .quarterly: return Calendar.current.date(byAdding: .month, value: 3, to: task.dueDate) ?? task.dueDate
        case .biannual: return Calendar.current.date(byAdding: .month, value: 6, to: task.dueDate) ?? task.dueDate
        case .yearly: return Calendar.current.date(byAdding: .year, value: 1, to: task.dueDate) ?? task.dueDate
        case .none: return task.dueDate
        }
    }
}
