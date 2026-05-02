import Foundation
import StoreKit

@MainActor
final class MonetizationService: ObservableObject {
    static let premiumProductID = "com.homepulse.premium.yearly"
    static let freePropertyLimit = 1
    static let freeActiveTaskLimit = 12

    @Published var products: [Product] = []
    @Published var purchasedPremium = false

    func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.premiumProductID])
            purchasedPremium = await hasPremiumEntitlement()
        } catch {
            print("StoreKit products error: \(error)")
        }
    }

    func purchasePremium() async {
        guard let product = products.first else { return }
        do {
            let result = try await product.purchase()
            if case .success(let verification) = result,
               case .verified(_) = verification {
                purchasedPremium = true
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func hasPremiumEntitlement() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.premiumProductID {
                return true
            }
        }
        return false
    }
}
