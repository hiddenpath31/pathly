//
//  Extension+Skarb.swift
//  pathly-vpn
//
//  Created by Александр on 22.11.2024.
//

import UIKit
import SkarbSDK

extension SkarbSDK {
    class func convertConversionInfoToAppsFlyerFormat(_ conversionInfo: [String : AnyObject]) -> [String : Any] {
        let timestamp = conversionInfo["+click_timestamp"]?.doubleValue
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp ?? 0))
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let formattedDateString = dateFormatter.string(from: date)

        var appsFlyerFormatData: [String: Any] = conversionInfo
        appsFlyerFormatData.updateKey(from: "~campaign", to: "campaign")
        appsFlyerFormatData["install_time"] = formattedDateString as NSString
        appsFlyerFormatData["media_source"] = conversionInfo["pid"]
        
        return appsFlyerFormatData
    }
}

extension Dictionary {
    mutating func updateKey(from: Key, to: Key) {
        self[to] = self[from]
        self.removeValue(forKey: from)
    }
}
