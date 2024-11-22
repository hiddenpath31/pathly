import Foundation
import StoreKit

public enum PurchaseResult {
    case success(VerificationResult<Transaction>)
    case userCancelled
    case pending
}

struct ProductDTO {
    var isSelected: Bool = false
    var singleDescription: String {
        var string = ""
        let trial: String = {
            if let trial = product.subscription?.introductoryOffer?.period.value {
                return "First \(trial) days free, then "
            } else {
                return ""
            }
        }()
        let period: String = {
            if let period = product.subscription?.subscriptionPeriod {
                if #available(iOS 15.4, *) {
                    return "/" + period.unit.localizedDescription
                } else {
                    return ""
                }
            } else {
                return ""
            }
        }()
        string = string + trial
        string = string + " " + product.displayPrice + period.lowercased()
        
        return string
    }
    
    var id: String
    var name: String
    var localizedPrice: String
    var displayTrial: String?
    var description: String?
    
    private var product: Product
    
    init(product: Product) {
        self.product = product
        self.name = product.displayName
        self.id = product.id
        if let trial = product.subscription?.introductoryOffer?.period.value {
            self.displayTrial = "First \(trial) days free"
        }
        self.description = product.description
        self.localizedPrice = product.displayPrice
    }
}

protocol StoreServiceInterface {
    var displayProducts: [ProductDTO] { get }
    var hasUnlockedPro: Bool { get }
    var didUpdate: Completion? { get set }
    
    func load(completion: Completion?)
    func pay(productId: String, completion: ((String?) -> Void)?)
}

final class StoreService {
    
    var displayProducts: [ProductDTO] {
        return products.map { product in
            var p = ProductDTO(product: product)
            if product.id == Constants.Subscription.defaultId {
                p.isSelected = true
            }
            return p
        }
    }
    
    private var productIds = Constants.Subscription.productIds
    private var products: [Product] = []
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    var didUpdate: Completion?
    
    var purchasedProductIDs = Set<String>() {
        didSet {
            self.didUpdate?()
        }
    }

    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    init() {
        self.updates = observeTransactionUpdates()
//        Task {
//            do {
//                try await loadProducts()
//                await updatePurchasedProducts()
//            } catch {
//                print("Ошибка загрузки продуктов: \(error)")
//            }
//        }
    }
    
    func load(completion: Completion?) {
        Task {
            do {
                try await loadProducts()
                await updatePurchasedProducts()
                completion?()
            } catch {
                print("Ошибка загрузки продуктов: \(error)")
                completion?()
            }
        }
    }
    
    private func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        
        do {
            let products = try await Product.products(for: productIds)
            self.products = productIds.compactMap { id in
                products.first { $0.id == id }
            }
            self.productsLoaded = true
        } catch {
            print("Ошибка загрузки продуктов: \(error)")
            throw error
        }
    }
    
    private func purchase(_ product: Product) async throws {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verificationResult):
                let transaction = try checkVerified(verificationResult)
                await self.updatePurchasedProducts()
                await transaction.finish()
            case .userCancelled:
                print("Пользователь отменил покупку")
            case .pending:
                print("Покупка ожидает подтверждения")
            @unknown default:
                print("Неизвестный результат покупки")
            }
        } catch {
            print("Ошибка покупки: \(error)")
            throw error
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let transaction):
            return transaction
        case .unverified(_, let error):
            print("Ошибка проверки транзакции: \(error)")
            throw error
        }
    }
    
    func pay(productId: String, completion: ((String?) -> Void)?) {
        guard let product = self.products.first(where: { $0.id == productId }) else {
            print("Продукт с ID \(productId) не найден")
            completion?("Продукт с ID \(productId) не найден")
            return
        }
        Task {
            do {
                try await self.purchase(product)
                completion?(nil)
            } catch {
                completion?(error.localizedDescription)
                print("Ошибка оплаты: \(error)")
            }
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                purchasedProductIDs.insert(transaction.productID)
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
    
    deinit {
        updates?.cancel()
    }
}

extension StoreService: StoreServiceInterface { }

