import SwiftUI

struct DashboardView: View {
    let tasks: [MaintenanceTask]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                MetricCard(title: "Due Now", count: dueNow.count, colors: [.orange, .pink])
                MetricCard(title: "Upcoming", count: upcoming.count, colors: [.blue, .cyan])
                MetricCard(title: "Overdue", count: overdue.count, colors: [.red, .purple])
                MetricCard(title: "Completed This Month", count: completedThisMonth.count, colors: [.green, .mint])
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var dueNow: [MaintenanceTask] { tasks.filter { Calendar.current.isDateInToday($0.dueDate) && $0.status != .completed } }
    private var upcoming: [MaintenanceTask] { tasks.filter { $0.dueDate > .now && $0.status != .completed } }
    private var overdue: [MaintenanceTask] { tasks.filter { $0.dueDate < .now && $0.status != .completed } }
    private var completedThisMonth: [MaintenanceTask] {
        tasks.filter { task in
            task.history.contains(where: { Calendar.current.isDate($0.completedAt, equalTo: .now, toGranularity: .month) })
        }
    }
}

struct MetricCard: View {
    let title: String
    let count: Int
    let colors: [Color]

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.headline)
                Text("\(count)").font(.system(size: 34, weight: .bold, design: .rounded))
            }
            Spacer()
            Image(systemName: "sparkles").font(.title)
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

#Preview {
    DashboardView(tasks: PreviewFixtures.sampleTasks())
}
