import SwiftUI
import SwiftData

struct RootTabView: View {
    @StateObject private var vm = TaskListViewModel()
    @StateObject private var monetization = MonetizationService()
    @Environment(\.modelContext) private var context
    @Query private var properties: [Property]
    @Query private var tasks: [MaintenanceTask]

    var body: some View {
        TabView {
            DashboardView(tasks: tasks)
                .tabItem { Label("Dashboard", systemImage: "chart.pie.fill") }

            TasksView(viewModel: vm, properties: properties, tasks: tasks)
                .tabItem { Label("Tasks", systemImage: "checklist") }

            PropertyListView(properties: properties, monetization: monetization)
                .tabItem { Label("Properties", systemImage: "house.fill") }

            SettingsView(monetization: monetization)
                .tabItem { Label("Premium", systemImage: "crown.fill") }
        }
        .task {
            await monetization.loadProducts()
            await NotificationService().requestPermission()
            seedSampleDataIfNeeded()
        }
    }

    private func seedSampleDataIfNeeded() {
        guard properties.isEmpty, tasks.isEmpty else { return }
        let home = Property(name: "Maple House", type: .home)
        let cabin = Property(name: "Pine Cabin", type: .cabin)
        context.insert(home)
        context.insert(cabin)

        MaintenanceTemplate.defaults.forEach { template in
            context.insert(template.makeTask(property: home))
        }
        try? context.save()
    }
}
