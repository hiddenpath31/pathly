//
//  Constants.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import Foundation

typealias Completion = (() -> Void)

struct Constants {
    
    struct BaseURL {
//        static let developURL: String = "https://bonpatapp.com/api"
//        static let productionURL: String = "https://bonpatapp.com/api"
        static let developURL: String = "https://set-pro.work/api/pathly"
        static let productionURL: String = "https://set-pro.work/api/pathly"
    }
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case acceptLanguage = "accept-language"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
    
    struct Subscription {
//        static let productIds = [
//            "ovulenmintertest1",
//            "ovulenmintertest2",
//            "ovulenmintertest3"
//        ]
        static let productIds = [
            "com.set.pathlypro.week",
            "com.set.pathlypro.month",
            "com.set.pathlypro.year"
        ]
//        static let defaultId = "ovulenmintertest2"
        static let defaultId = "com.set.pathlypro.month"
        static let sharedKey = ""
    }
    
    static let apiKey: String = "4de792bb-a5f3-4717-b02b-fa7d01ce35f6"
    
    struct Support {
        static let email: String = "alan@set-pro.work"
        static let policy: String = "https://set-pro.work/private-policy.html"
        static let terms: String = "https://set-pro.work/terms-of-use.html"
        static let privacyContent = L10n.privacyPolicy
    }
    
}

struct Localize {
    struct AlertSale {
        static let title = NSLocalizedString("Special Offer!🎁", comment: "")
        static let subtitle = NSLocalizedString("To get full access to the vpn you need to subscribe", comment: "")
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let get = NSLocalizedString("Get", comment: "")
    }
    
    struct Error {
        struct TryAgain {
            static let title =  NSLocalizedString("The device is not protected", comment: "")
            static let subtitle =  NSLocalizedString("Enable protection", comment: "")
            static let okButton =  NSLocalizedString("Try Again", comment: "")
        }
    }
    
    static let userComment = NSLocalizedString("This VPN is for people like me for simple safe connection to unknown and public wifi no other weird and confusing buttons. The connection is very fast and i have no problem using it. 👍 👍 👍", comment: "")
}

struct ProtectionError: LocalizedError {
    let title: String
    let subtitle: String
    let buttonTitle: String

    var errorDescription: String? {
        return subtitle
    }

    var failureReason: String? {
        return title
    }

    var recoverySuggestion: String? {
        return buttonTitle
    }
}
