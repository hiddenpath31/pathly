//
//  Extension+Alertable.swift
//  odola-app
//
//  Created by Александр on 11.09.2024.
//

import Foundation
import UIKit

protocol Alertable {
    func showAlert(message: String, completion: Completion?)
    func showAlert(title: String, message: String, completion: Completion?)
    func showAlert(message: String, actionTitle: String, cancelTitle: String?, completion: Completion?)
    func showAttemptAlert(message: String, completion: Completion?)
}

extension Alertable where Self: UIViewController {

    func showAlert(title: String, message: String, completion: Completion?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completion?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func showAlert(message: String, completion: Completion?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completion?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func showAlert(message: String, actionTitle: String, cancelTitle: String? = nil, completion: Completion?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default) { action in
            completion?()
        }
        alert.addAction(okAction)
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true)
    }
    
    func showAttemptAlert(message: String, completion: Completion?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "Yes", style: .default) { action in
            completion?()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}
