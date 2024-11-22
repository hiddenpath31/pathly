//
//  FunnelFlowPresenter.swift
//  GrowVPN
//
//  Created by Александр on 29.08.2024.
//

import Foundation
import Combine

protocol FunnelFlowPresenterDelegate: AnyObject {
    func funnelFlowDidEnterBackground(presenter: FunnelFlowPresenterInterface)
    func funnelFlowDidCaptureScreen(presenter: FunnelFlowPresenterInterface)
    func funnelFlowDidEndFlow(presenter: FunnelFlowPresenterInterface)
}

protocol FunnelFlowPresenterInterface: AnyObject {

    func viewDidLoad()
    func viewDidEnterBackground()
    func viewCaptureScreen()

    func nextIteration()
    func subscribe()
    
}

class FunnelFlowPresenter {
    
    weak var view: FunnelFlowView?
    weak var delegate: FunnelFlowPresenterDelegate?
    
    private var apiService: APINetworkServiceInterface
    private var storeService: StoreServiceInterface
    private var funnelModel: FunnelModel
    private var currentOrder: Int = 0
    private let conversionInfo: [AnyHashable: Any]?
    
    init(view: FunnelFlowView, funnelModel: FunnelModel, apiService: APINetworkServiceInterface, storeService: StoreServiceInterface) {
        self.view = view
        self.funnelModel = funnelModel
        self.conversionInfo = AnalyticsValues.conversionInfo
        self.apiService = apiService
        self.storeService = storeService
    }
    
}

extension FunnelFlowPresenter: FunnelFlowPresenterInterface {
    
    func viewDidLoad() {
        if let first = self.funnelModel.iterations.first {
            self.view?.initial(firstIteration: first)
        }
        
        self.sendEventFirstScreen()
        self.storeService.didUpdate = {
            
        }
    }
    
    func viewDidEnterBackground() {
        self.sendEventBreak()
        self.delegate?.funnelFlowDidEnterBackground(presenter: self)
    }
    
    func viewCaptureScreen() {
        self.sendEventBreak()
        self.delegate?.funnelFlowDidCaptureScreen(presenter: self)
    }
    
    @MainActor func nextIteration() {
        let iteration = self.funnelModel.iterations[self.currentOrder]
        
        if iteration.key == "highRisk" {
            self.subscribe()
            return
        }
        
        if currentOrder + 1 < self.funnelModel.iterations.count {
            self.currentOrder += 1
            let iteration = self.funnelModel.iterations[self.currentOrder]
            self.view?.show(iteration: iteration)
            
            if iteration.key == "highRisk" {
                self.sendEventPaywall()
            }
            
            if currentOrder + 1 == self.funnelModel.iterations.count {
                self.sendEventLastScreen()
            }
        } else {
            self.delegate?.funnelFlowDidEndFlow(presenter: self)
        }
    }
    
    func purchased() {
        self.sendEventSuccessfullPurchase()
        if currentOrder + 1 < self.funnelModel.iterations.count {
            self.currentOrder += 1
            let iteration = self.funnelModel.iterations[self.currentOrder]
            self.view?.show(iteration: iteration)
        }
    }
    
    func trackSubscribeEvent() {
        guard let subscriptionId = funnelModel.subscriptionId else {
            return
        }
        let requestEvent = EventRequest(
            api_key: Constants.apiKey,
            event: .subscribe,
            product: subscriptionId,
            af_data: self.conversionInfo ?? [:]
        )
        self.apiService.application.sendEvent(requestData: requestEvent)
    }
    
    @MainActor
    func subscribe() {
        guard let subscriptionId = funnelModel.subscriptionId else {
            return
        }
        
        self.view?.showHUD()
        self.storeService.pay(
            productId: subscriptionId,
            completion: { [weak self] errorString in
                DispatchQueue.main.async {
                    self?.view?.hideHUD()
                    guard let strongSelf = self else { return }
                    
                    if let errorString = errorString {
                        if let fail = strongSelf.funnelModel.failAlert {
                            strongSelf.view?.showRCAlert(alert: fail)
                        } else {
                            strongSelf.view?.showTryAgainError()
                        }
                    } else {
                        strongSelf.trackSubscribeEvent()
                        UserDefaults.standard.set(true, forKey: "premium")
                        strongSelf.purchased()
                    }
                }
            }
        )
    }
    
    private func trackSubscribeEvent(productId: String) {
        let requestEvent = EventRequest(
            api_key: Constants.apiKey,
            event: .subscribe,
            product: productId,
            af_data: self.conversionInfo ?? [:]
        )
        self.apiService.application.sendEvent(requestData: requestEvent)
    }
    
    private func sendEventFirstScreen() {
        if self.funnelModel.identifier == 1 {
            AnalyticService.shared.sendEvent(.firstScreen1)
        } else if  self.funnelModel.identifier == 155 {
            AnalyticService.shared.sendEvent(.firstScreen2)
        }
    }
    
    private func sendEventLastScreen() {
        if self.funnelModel.identifier == 1 {
            AnalyticService.shared.sendEvent(.lastScreen1)
        } else if  self.funnelModel.identifier == 155 {
            AnalyticService.shared.sendEvent(.lastScreen1)
        }
    }
    
    private func sendEventSuccessfullPurchase() {
        if self.funnelModel.identifier == 1 {
            AnalyticService.shared.sendEvent(.sub1)
        } else if  self.funnelModel.identifier == 155 {
            AnalyticService.shared.sendEvent(.sub2)
        }
    }
    
    private func sendEventPaywall() {
        if self.funnelModel.identifier == 1 {
            AnalyticService.shared.sendEvent(.paywall1)
        } else if  self.funnelModel.identifier == 155 {
            AnalyticService.shared.sendEvent(.paywall2)
        }
    }
    
    private func sendEventBreak() {
        if self.funnelModel.identifier == 1 {
            AnalyticService.shared.sendEvent(.breakFunnel1)
        } else if  self.funnelModel.identifier == 155 {
            AnalyticService.shared.sendEvent(.breakFunnel2)
        }
    }
    
}
