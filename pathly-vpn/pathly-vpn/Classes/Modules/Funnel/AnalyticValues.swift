//
//  AnalyticValues.swift
//  pathly-vpn
//
//  Created by Александр on 21.11.2024.
//

import Foundation
import StoreKit

class AnalyticsValues {
    static var appKey: String?
    static var mediaSource: String?
    static var afStatus: String?
    static var isFirstLaunch: Bool?
    static var planForOnboarding: [SKProduct]?
    static var isFirstLaunchFlag: Bool?
    static var conversionInfo: [AnyHashable: Any]?
    static var planForPromo: SKProduct?
    static var planForPromoFlow: SKProduct?
    static var planForThreelong: SKProduct?
}
