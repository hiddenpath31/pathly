//
//  PaywallPresenter.swift
//  pathly-vpn
//
//  Created by Александр on 10.11.2024.
//

import UIKit
import SkarbSDK

protocol PaywallPresenterInterface {
    var view: PaywallView? { get set }
    var didEvent: PaywallViewEventHandler? { get set }
    var items: [SinglePaywallItem] { get }
    
    func viewDidLoad()
    func pay()
    func productDidSelect(id: String)
}

class PaywallPresenter {
    weak var view: PaywallView?
    var didEvent: PaywallViewEventHandler?

    private var storeService: StoreServiceInterface
    private var apiService: APINetworkServiceInterface
    private var storageService: StorageServiceInterface
    private var type: Paywall
    private var products: [ProductDTO] = []
    private var current: ProductDTO? {
        return products.first(where: { $0.isSelected == true })
    }
    var items: [SinglePaywallItem] {
        let paywall = self.storageService.remoteRespone?.paywall ?? PaywallLocalize()
        let items = [
            SinglePaywallItem.secure(string: paywall.secureString),
            SinglePaywallItem.protection(string: paywall.protectionString),
            SinglePaywallItem.verification(string: paywall.verificationString)
        ]
        return items
    }
    
    init(view: PaywallView, storeService: StoreServiceInterface, apiService: APINetworkServiceInterface, storageService: StorageServiceInterface, type: Paywall) {
        self.view = view
        self.storeService = storeService
        self.storageService = storageService
        self.apiService = apiService
        self.type = type
    }
    
    private func setupBindings() {
        self.didEvent = { [weak self] event in
            switch event {
            case .dismiss:
                self?.view?.dismiss()
            case .terms:
                if let url = URL(string: Constants.Support.terms) {
                    UIApplication.shared.open(url)
                }
            case .privacy:
                if let url = URL(string: Constants.Support.policy) {
                    UIApplication.shared.open(url)
                }
            default:
                break
            }
        }
        self.storeService.didUpdate = { [weak self] in
            if self?.storeService.hasUnlockedPro == true {
                self?.didEvent?(.dismiss)
            }
        }
    }
    
}


extension PaywallPresenter: PaywallPresenterInterface {
    
    func viewDidLoad() {
        setupBindings()

        self.products = storeService.displayProducts.map({ product in
            var p = product
            if let product = self.storageService.remoteRespone?.productLocalize?.first(where: { $0.productId == product.id }) {
                p.description = product.description
                p.name = product.name
            }
            return p
        })
        
        switch type {
            case .multy:
                self.view?.display(
                    products: self.products,
                    paywallLocalize: self.storageService.remoteRespone?.paywall ?? PaywallLocalize()
                )
                SkarbSDK.sendTest(name: "pw_one", group: "")
            case .single(let dismissDelay):
                SkarbSDK.sendTest(name: "pw_threelong", group: "")
                self.view?.display(
                    productDescription: self.current?.singleDescription ?? "",
                    dismissDelay: dismissDelay,
                    paywallLocalize: self.storageService.remoteRespone?.paywall ?? PaywallLocalize()
                )
        }
        
    }
    
    func pay() {
        if let current = current {
            self.view?.startLoading()
            self.storeService.pay(productId: current.id, completion: { [weak self] errorString in
                self?.view?.stopLoading()
                if errorString == nil {
                    self?.trackSubscribeEvent(productId: current.id)
                }
            })
        }
    }
    
    private func trackSubscribeEvent(productId: String) {
        let requestEvent = EventRequest(
            api_key: Constants.apiKey,
            event: .subscribe,
            product: productId,
            af_data: AnalyticsValues.conversionInfo
        )
        self.apiService.application.sendEvent(requestData: requestEvent)
    }
    
    func productDidSelect(id: String) {
        if let selectProduct = self.products.first(where: { $0.isSelected == true }) {
            if selectProduct.id == id {
                return
            }
        }
        
        self.products = self.products.map({ product in
            var newProduct = product
            newProduct.isSelected = product.id == id
            return newProduct
        })
        self.view?.display(products: self.products, paywallLocalize: nil)
    }
    
}
