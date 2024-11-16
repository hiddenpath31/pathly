//
//  PaywallPresenter.swift
//  pathly-vpn
//
//  Created by Александр on 10.11.2024.
//

import UIKit

protocol PaywallPresenterInterface {
    var view: PaywallView? { get set }
    var didEvent: PaywallViewEventHandler? { get set }
    
    func viewDidLoad()
    func pay()
    func productDidSelect(id: String)
}

class PaywallPresenter {
    weak var view: PaywallView?
    var didEvent: PaywallViewEventHandler?

    private var storeService: StoreServiceInterface
    private var type: Paywall
    private var products: [ProductDTO] = []
    private var current: ProductDTO? {
        return products.first(where: { $0.isSelected == true })
    }
    
    init(view: PaywallView, storeService: StoreServiceInterface, type: Paywall) {
        self.view = view
        self.storeService = storeService
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

        self.products = storeService.displayProducts
        
        switch type {
            case .multy:
                self.view?.display(products: self.products)
            case .single:
                self.view?.display(productDescription: self.current?.singleDescription ?? "")
        }
    }
    
    func pay() {
        if let current = current {
            self.storeService.pay(productId: current.id)
        }
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
        self.view?.display(products: self.products)
    }
    
}
