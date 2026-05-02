import Foundation
import UserNotifications

struct NotificationService {
    func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
    }

    func scheduleReminder(for task: MaintenanceTask) {
        let content = UNMutableNotificationContent()
        content.title = "HomePulse Reminder"
        content.body = "\(task.title) is due on \(task.dueDate.formatted(date: .abbreviated, time: .omitted))."
        content.sound = .default

        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour], from: task.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
