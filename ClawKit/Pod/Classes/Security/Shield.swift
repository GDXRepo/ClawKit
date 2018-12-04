//
//  Shield.swift
//  Sample
//
//  Created by Georgiy Malyukov on 04/12/2018.
//  Copyright © 2018 GDXRepo. All rights reserved.
//

import UIKit

public final class Shield {
    
    private static var view: UIVisualEffectView?
    
    public static func onDidEnterBackground() {
        view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view!.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(view!)
    }
    
    public static func onDidBecomeActive() {
        UIView.animate(withDuration: 0.15, animations: {
            view?.alpha = 0
        }) { _ in
            view?.removeFromSuperview()
            view = nil
        }
    }
    
}
