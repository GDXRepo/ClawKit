//
//  UIViewController+Ext.swift
//  Sample
//
//  Created by Георгий Малюков on 31.08.2018.
//  Copyright © 2018 GDXRepo. All rights reserved.
//

import UIKit

public typealias VoidBlock = () -> ()

extension UIViewController {
    
    public func addChild(controller: UIViewController, onContainer view: UIView, animation: (duration: TimeInterval, options: UIViewAnimationOptions, animations: VoidBlock)? = nil) {
        if let anim = animation {
            addChildViewController(controller)
            controller.beginAppearanceTransition(true, animated: true)
            view.addSubview(controller.view)
            UIView.transition(with: view, duration: anim.duration, options: anim.options, animations: {
                anim.animations()
            }) { _ in
                controller.endAppearanceTransition()
                controller.didMove(toParentViewController: self)
            }
        } else {
            addChildViewController(controller)
            view.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
    }
    
    public func removeChild(controller: UIViewController, animation: (duration: TimeInterval, options: UIViewAnimationOptions, animations: VoidBlock)? = nil) {
        if let anim = animation {
            controller.willMove(toParentViewController: nil)
            controller.beginAppearanceTransition(false, animated: true)
            UIView.transition(with: view, duration: anim.duration, options: anim.options, animations: {
                controller.view.removeFromSuperview()
                anim.animations()
            }) { _ in
                controller.endAppearanceTransition()
                controller.removeFromParentViewController()
            }
        } else {
            controller.willMove(toParentViewController: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
    }
    
    public func removeFromParent(animation: (duration: TimeInterval, options: UIViewAnimationOptions, animations: VoidBlock)? = nil) {
        removeChild(controller: self, animation: animation)
    }
    
}
