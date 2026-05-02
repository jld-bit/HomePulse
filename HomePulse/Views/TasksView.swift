import SwiftUI
import SwiftData

struct TasksView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: TaskListViewModel
    let properties: [Property]
    let tasks: [MaintenanceTask]

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.filteredTasks(tasks).isEmpty {
                    ContentUnavailableView("No tasks yet", systemImage: "leaf.fill", description: Text("Add your first maintenance item to start building momentum."))
                } else {
                    List(viewModel.filteredTasks(tasks)) { task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.title).font(.headline)
                                Text(task.property?.name ?? "No Property").font(.caption)
                            }
                            Spacer()
                            Text(task.status.label)
                                .padding(.horizontal, 10).padding(.vertical, 4)
                                .background(.thinMaterial)
                                .clipShape(Capsule())
                        }
                        .swipeActions {
                            Button("Done") { viewModel.markCompleted(task, context: context) }.tint(.green)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Menu("Category") { ForEach(TaskCategory.allCases) { c in Button(c.title) { viewModel.selectedCategory = c } } } }
                ToolbarItem(placement: .topBarTrailing) { Menu("Status") { ForEach(TaskStatus.allCases) { s in Button(s.label) { viewModel.selectedStatus = s } } } }
            }
            .navigationTitle("Maintenance")
        }
    }
}

#Preview {
    TasksView(viewModel: TaskListViewModel(), properties: [PreviewFixtures.sampleProperty()], tasks: PreviewFixtures.sampleTasks())
}
