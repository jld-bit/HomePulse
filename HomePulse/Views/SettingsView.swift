import SwiftUI

struct SettingsView: View {
    @ObservedObject var monetization: MonetizationService

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("PulsePlus Premium").font(.largeTitle.bold())
                Text("Unlock unlimited properties, full history, export, and custom themes.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button("Upgrade with StoreKit 2") {
                    Task { await monetization.purchasePremium() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Premium")
        }
    }
}
