//
//  UIView+Ext.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 09.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func performLayout(animated: Bool = true) {
        if superview != nil {
            setNeedsUpdateConstraints()
            setNeedsLayout()
            UIView.animate(withDuration: (animated) ? 0.25 : 0) { [unowned self] in
                self.updateConstraintsIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }
    
}
