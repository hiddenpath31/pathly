//
//  TabItem.swift
//  odola-app
//
//  Created by Александр on 27.09.2024.
//

import Foundation
import UIKit

enum TabItem {
    case data
    case vpn
    case settings
    
    var icon: UIImage {
        switch self {
            case .data:
                return Asset.tabData.image
            case .vpn:
                return Asset.tabVpn.image
            case .settings:
                return Asset.tabSettings.image
        }
    }
    
    var title: String {
        switch self {
            case .data:
                return L10n.Tab.data
            case .vpn:
                return L10n.Tab.vpn
            case .settings:
                return L10n.Tab.settings
        }
    }
}
