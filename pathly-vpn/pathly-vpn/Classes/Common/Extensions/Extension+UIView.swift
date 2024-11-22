//
//  Extension+UIView.swift
//  odola-app
//
//  Created by Александр on 28.09.2024.
//

import Foundation
import UIKit

extension UIView {
    
    func cornered(radius: CGFloat? = nil) {
        if let radius = radius {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.height / 2
        }
    }
    
    func bordered(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func unbordered() {
        self.layer.borderWidth = 0
    }
    
    
}

extension UIView {
    
    func transformMaxWithBounce(completion: Completion?) {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.alpha = 0
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.transform = CGAffineTransform.identity
                self?.alpha = 1
            }) { _ in
                completion?()
            }
    }
    
}

extension UIAlertController {
    
    convenience init(error: LocalizedError, completion: (() -> Void)? = nil) {
        self.init(title: error.failureReason, message: error.errorDescription, preferredStyle: .alert)
        addAction(UIAlertAction(title: error.recoverySuggestion, style: .default) { _ in
            completion?()
        })
    }
    
}
