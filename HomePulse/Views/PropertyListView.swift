import SwiftUI

struct PropertyListView: View {
    let properties: [Property]
    @ObservedObject var monetization: MonetizationService

    var body: some View {
        NavigationStack {
            List(properties) { property in
                VStack(alignment: .leading) {
                    Text(property.name).font(.headline)
                    Text(property.type.title).font(.caption).foregroundStyle(.secondary)
                }
            }
            .overlay {
                if properties.isEmpty {
                    ContentUnavailableView("No properties", systemImage: "house", description: Text("Add a Home, Rental, or Cabin to organize tasks."))
                }
            }
            .navigationTitle("Properties")
            .toolbar {
                if !monetization.purchasedPremium && properties.count >= MonetizationService.freePropertyLimit {
                    Text("Free limit reached").font(.caption).foregroundStyle(.orange)
                }
            }
        }
    }
}
