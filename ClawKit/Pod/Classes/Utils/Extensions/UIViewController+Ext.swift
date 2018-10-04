//
//  UIViewController+Ext.swift
//  Sample
//
//  Created by Georgiy Malyukov on 31.08.2018.
//  Copyright © 2018 GDXRepo. All rights reserved.
//

import UIKit

public typealias VoidBlock = () -> ()

extension UIViewController {
    
    public func addChild(controller: UIViewController, onContainer view: UIView, animation: (duration: TimeInterval, options: UIView.AnimationOptions, animations: VoidBlock)? = nil) {
        if let anim = animation {
            addChild(controller)
            controller.beginAppearanceTransition(true, animated: true)
            view.addSubview(controller.view)
            UIView.transition(with: view, duration: anim.duration, options: anim.options, animations: {
                anim.animations()
            }) { _ in
                controller.endAppearanceTransition()
                controller.didMove(toParent: self)
            }
        } else {
            addChild(controller)
            view.addSubview(controller.view)
            controller.didMove(toParent: self)
        }
    }
    
    public func removeChild(controller: UIViewController, animation: (duration: TimeInterval, options: UIView.AnimationOptions, animations: VoidBlock)? = nil) {
        if let anim = animation {
            controller.willMove(toParent: nil)
            controller.beginAppearanceTransition(false, animated: true)
            UIView.transition(with: view, duration: anim.duration, options: anim.options, animations: {
                controller.view.removeFromSuperview()
                anim.animations()
            }) { _ in
                controller.endAppearanceTransition()
                controller.removeFromParent()
            }
        } else {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
        }
    }
    
    public func removeFromParent(animation: (duration: TimeInterval, options: UIView.AnimationOptions, animations: VoidBlock)? = nil) {
        removeChild(controller: self, animation: animation)
    }
    
}
