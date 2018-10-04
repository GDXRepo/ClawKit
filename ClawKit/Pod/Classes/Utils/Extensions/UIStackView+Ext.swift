//
//  UIStackView+Ext.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 27.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    public func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        // Deactivate all constraints & remove subviews
        removedSubviews.forEach { view in
            view.snp.removeConstraints()
            view.removeFromSuperview()
        }
    }
}
