//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

import UIKit

public extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        _execute(animated: animated, completion: completion)
    }
    
    @discardableResult
    func popViewController(animated: Bool, completion: @escaping () -> Void) -> UIViewController? {
        let viewController = popViewController(animated: animated)
        _execute(animated: animated, completion: completion)
        return viewController
    }
    
    @discardableResult
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) -> [UIViewController]? {
        let viewControllers = popToViewController(viewController, animated: animated)
        _execute(animated: animated, completion: completion)
        return viewControllers
    }
    
    @discardableResult
    func popToRootViewController(animated: Bool, completion: @escaping () -> Void) -> [UIViewController]? {
        let viewControllers = popToRootViewController(animated: animated)
        _execute(animated: animated, completion: completion)
        return viewControllers
    }
    
    private func _execute(animated: Bool, completion: @escaping () -> Void) {
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async(execute: completion)
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}

#endif
