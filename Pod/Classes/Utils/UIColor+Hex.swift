//
//  UIColor+Hex.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 09.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            r: (rgb >> 16) & 0xFF,
            g: (rgb >> 8) & 0xFF,
            b: rgb & 0xFF,
            a: a
        )
    }
    
}
