//
//  FunnelCoordinator.swift
//  GrowVPN
//
//  Created by Александр on 29.08.2024.
//

import UIKit
import Foundation

enum FunnelFlowType {
    case flow1(model: FunnelModel)
    case flow2(model: FunnelModel)
}

protocol FunnelCoordinatorDelegate: AnyObject {
    
    func funnelCoordinatorDidEnterBackground(coordinator: FunnelCoordinator)
    func funnelCoordinatorDidCaptureScreen(coordinator: FunnelCoordinator)
    func funnelCoordinatorDidEndFlow(coordinator: FunnelCoordinator)
    
}

class FunnelCoordinator: Coordinator {
    private var navigationController: UINavigationController
    private var flowType: FunnelFlowType
    private var funnelModel: FunnelModel
    private var storeService: StoreServiceInterface
    private var apiService: APINetworkServiceInterface
    
    var childCoordinators: [Coordinator] = []
    weak var delegate: FunnelCoordinatorDelegate?
    
    init(navigationController: UINavigationController, flowType: FunnelFlowType, storeService: StoreServiceInterface, apiService: APINetworkServiceInterface) {
        self.navigationController = navigationController
        self.flowType = flowType
        self.storeService = storeService
        self.apiService = apiService
        
        switch flowType {
            case .flow1(let model):
                self.funnelModel = model
            case .flow2(let model):
                self.funnelModel = model
        }

    }
    
    func start() {
        switch self.flowType {
        case .flow1(let model):
            scanCheckFlow()
        case .flow2(let model):
            scanPhoneFlow()
        }

    }
    
    func scanCheckFlow() {
        let viewController = FunnelFlowCheckPhoneViewController()
        let presenter = FunnelFlowPresenter(
            view: viewController,
            funnelModel: self.funnelModel,
            apiService: self.apiService,
            storeService: self.storeService
        )
        presenter.delegate = self
        viewController.presenter = presenter
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func scanPhoneFlow() {
        let viewController = FunnelFlowScanPhoneViewController()
        let presenter = FunnelFlowPresenter(
            view: viewController,
            funnelModel: self.funnelModel,
            apiService: self.apiService,
            storeService: self.storeService
        )
        presenter.delegate = self
        viewController.presenter = presenter
        
        navigationController.setViewControllers([viewController], animated: false)
    }
        
    func finish() {
        //
    }
    
    func applicationHandlerEvent(_ event: ApplicationEvent) {
        //
    }
    
}

extension FunnelCoordinator: FunnelFlowPresenterDelegate {
    
    func funnelFlowDidEnterBackground(presenter: FunnelFlowPresenterInterface) {
        self.delegate?.funnelCoordinatorDidEnterBackground(coordinator: self)
    }
    
    func funnelFlowDidCaptureScreen(presenter: FunnelFlowPresenterInterface) {
        self.delegate?.funnelCoordinatorDidCaptureScreen(coordinator: self)
    }
    
    func funnelFlowDidEndFlow(presenter: FunnelFlowPresenterInterface) {
        self.delegate?.funnelCoordinatorDidEndFlow(coordinator: self)
    }
    
}
