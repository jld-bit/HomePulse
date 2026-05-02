import SwiftUI
import SwiftData

@main
struct HomePulseApp: App {
    let container: ModelContainer

    init() {
        do {
            let schema = Schema([
                Property.self,
                MaintenanceTask.self,
                TaskHistory.self,
                AppPreferences.self
            ])
            let config = ModelConfiguration("HomePulseData")
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to initialize SwiftData: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .modelContainer(container)
        }
    }
}
