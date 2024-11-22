//
//  SubscribeEventRequest.swift
//  pathly-vpn
//
//  Created by Александр on 22.11.2024.
//

import Foundation

enum EventType: String {
    case install = "install"
    case subscribe = "subscribe"
}


struct EventRequest {
    var api_key: String
    var event: EventType
    var product: String?
    var af_data: [AnyHashable: Any]?
    
    func doDict() -> [String: Any] {
        var dict = [String: Any]()
        dict["api_key"] = self.api_key
        dict["af_data"] = self.af_data
        dict["event"] = self.event.rawValue
        dict["product"] = self.product
        return dict
    }
    
}
