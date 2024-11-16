//
//  Coordinator.swift
//  odola-app
//
//  Created by Александр on 09.09.2024.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }

    func start()
    func clearChildCoordinators()
    func finish()
    
    func applicationHandlerEvent(_ event: ApplicationEvent)
}

enum ApplicationEvent {
    case didBecomeActive
    case didEnterBackground
    case willTerminate
    case subscribeActivated
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func getChildCoordinators<T: Coordinator>(ofType type: T.Type) -> [T] {
        var coordinatorsOfType: [T] = []

        for child in childCoordinators {
            if let coordinatorOfType = child as? T {
                coordinatorsOfType.append(coordinatorOfType)
            }
            coordinatorsOfType += child.getChildCoordinators(ofType: type)
        }

        return coordinatorsOfType
    }
    
    func clearChildCoordinators() {
        for child in childCoordinators {
            child.clearChildCoordinators()
        }
        childCoordinators = []
        finish()
    }
    
}
