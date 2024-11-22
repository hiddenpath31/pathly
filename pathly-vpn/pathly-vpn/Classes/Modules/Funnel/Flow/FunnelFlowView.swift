//
//  FunnelFlowView.swift
//  GrowVPN
//
//  Created by Александр on 29.08.2024.
//

import Foundation

protocol FunnelFlowView: AnyObject {
    var presenter: FunnelFlowPresenterInterface? { get set }

    func initial(firstIteration: FunnelScanPhoneIterationModel)
    func show(iteration: FunnelScanPhoneIterationModel)
    func showHUD()
    func hideHUD()
    func showTryAgainError()
    func show(_ error: Error) 
    func showRCAlert(alert: FailAlert)
    
}
