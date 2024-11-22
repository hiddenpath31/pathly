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
