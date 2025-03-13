//
//  Funnel.swift
//  NowaguardVPN
//
//  Created by Александр on 08.10.2024.
//

import Foundation
import UIKit

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
