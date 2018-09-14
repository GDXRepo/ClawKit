//
//  UIStackView+Ext.swift
//  Worldcore
//
//  Created by Георгий Малюков on 27.08.2018.
//  Copyright © 2018 EUPSprovider s.r.o. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
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
