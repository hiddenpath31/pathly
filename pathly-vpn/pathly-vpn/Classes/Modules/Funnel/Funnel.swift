//
//  Funnel.swift
//  NowaguardVPN
//
//  Created by Александр on 08.10.2024.
//

import Foundation
import UIKit

struct Funnels {
    var scanFlow: FunnelModel?
    var checkFlow: FunnelModel?
}

struct FunnelModel: Codable {
    var identifier: Int
    var type: String
    var subscriptionId: String?
    var failAlert: FailAlert?
    var iterations: [FunnelScanPhoneIterationModel]
}

struct RemoteSubscription: Codable {
    var productId: String
    var description: String
    var name: String
}

struct PaywallLocalize: Codable {
    var title: String?
    var description: String?
    var actionButton: String?
    var termsOfUse: String?
    var privacyPolicy: String?
    
    var secure: String?
    var protection: String?
    var verification: String?
    var first: String?
    var then: String?
    var daysFree: String?
    
    var titleString: String {
        return title ?? "Go Premium"
    }
    var descriptionString: String {
        return description ?? "Unlock the full power of this mobile tool and enjoy a digital experience like never!"
    }
    var actionButtonString: String {
        return actionButton ?? "Start & Subscribe"
    }
    var termsOfUseString: String {
        return termsOfUse ?? "Terms of use"
    }
    var privacyPolicyString: String {
        return privacyPolicy ?? "Privacy Policy"
    }
    
    var secureString: String {
        return secure ?? "VPN Secure"
    }
    var protectionString: String {
        return protection ?? "The Strongest Protection"
    }
    var verificationString: String {
        return verification ?? "IP Verifications"
    }
    var firstString: String {
        return first ?? "First"
    }
    var thenString: String {
        return then ?? "days free, then"
    }
    var daysFreeString: String {
        return daysFree ?? "days free"
    }
    
    init(title: String? = nil, description: String? = nil, actionButton: String? = nil, termsOfUse: String? = nil, privacyPolicy: String? = nil, secure: String? = nil, protection: String? = nil, verification: String? = nil, first: String? = nil, then: String? = nil) {
        self.title = title
        self.description = description
        self.actionButton = actionButton
        self.termsOfUse = termsOfUse
        self.privacyPolicy = privacyPolicy
        self.secure = secure
        self.protection = protection
        self.verification = verification
        self.first = first
        self.then = then
    }
    
}

struct FailAlert: Codable {
    var title: String
    var description: String
    var okButton: String
}

struct FunnelScanPhoneIterationModel: Codable {
    var order: Int
    var key: String
    var title: String
    var attributedTitle: FunnelAttributedTextModel?
    var subtitle: String?
    var scrollContent: [String]?
    var checks: [FunnelCheck]?
    var scrollCategoryContent: [FunnelCategoryModel]?
    var actionString: String?
    var status: String?
    
    func attributed() -> [NSAttributedString.Key: Any]? {
        if let attributedTitle = self.attributedTitle {
            let color: UIColor = UIColor(hex: attributedTitle.color ?? "#555555") ?? UIColor.white
            let size = attributedTitle.size
            let weight: UIFont.Weight = {
                switch attributedTitle.weight {
                    case "regular":
                        return .regular
                    case "bold":
                        return .bold
                    case "medium":
                        return .medium
                    case "semibold":
                        return .semibold
                    default:
                        return .regular
                }
            }()
            let font: UIFont = UIFont.systemFont(ofSize: CGFloat(size), weight: weight)
            
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: font
            ]
            return attributes
        }
        
        return nil
    }
}

struct FunnelCategoryModel: Codable {
    var icon: String?
    var text: String
}

struct FunnelAttributedTextModel: Codable {
    var color: String?
    var size: Int
    var weight: String
}

struct FunnelCheck: Codable {
    var key: String
    var errorColor: String?
    var successColor: String
    var title: String?
    var availableString: String?
    var moreString: String?
    var contents: [String]
    
    var error: UIColor {
        return UIColor(hex: errorColor ?? "FF0000")
    }
    var success: UIColor {
        return UIColor(hex: successColor ?? "008000")
    }
    
}
