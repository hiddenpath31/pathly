//
//  AnalyticService.swift
//  GrowVPN
//
//  Created by Александр on 07.10.2024.
//

import Foundation
import FirebaseAnalytics

class AnalyticService {
    
    enum Event: String {
        case firstLaunch
        case firstScreen1
        case firstScreen2
        case paywall1
        case paywall2
        case sub1
        case sub2
        case lastScreen1
        case lastScreen2
        case breakFunnel1
        case breakFunnel2
    }
    
    static let shared = AnalyticService()
    
    func sendEvent(_ event: Event) {
        Analytics.logEvent(event.rawValue, parameters: nil)
    }
    
}
