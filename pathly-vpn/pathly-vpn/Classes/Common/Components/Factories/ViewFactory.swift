//
//  ViewFactory.swift
//  odola-app
//
//  Created by Александр on 09.09.2024.
//

import Foundation
import UIKit

struct ViewFactory {
    
    struct Buttons {
        
        static func base() -> UIButton {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 20
            button.backgroundColor = Asset.accentColor.color
            button.setTitleColor(Asset.backgroundColor.color, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            return button
        }
        
        static func opaque() -> UIButton {
            let button = ViewFactory.Buttons.base()
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            return button
        }
        
    }
    
    static func stack(_ axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) -> UIStackView {
        var stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        return stack
    }
    
    static func label(font: UIFont, color: UIColor) -> UILabel {
        var label = UILabel()
        label.font = font
        label.textColor = color
        return label
    }
    
}
