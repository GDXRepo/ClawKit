//
//  Gradient.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 09.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

public struct Gradient {
    
    var colors: [UIColor]
    var start: CGPoint = .zero
    var end: CGPoint = CGPoint(x: 1, y: 1)
    
    public init(colors: [UIColor]) {
        assert(colors.count > 1, "Invalid gradient stops count.")
        self.colors = colors
    }
    
    public init(colors: [UIColor], start: CGPoint, end: CGPoint) {
        self.init(colors: colors)
        assert(start != end, "Gradient points must not be equal.")
        self.start = start
        self.end = end
    }
    
}

extension Gradient {
    
    @discardableResult
    public func add(to view: UIView) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = colors.map { color -> CGColor in
            return color.cgColor
        }
        layer.startPoint = start
        layer.endPoint = end
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.layer.insertSublayer(layer, at: 0)
        return layer
    }
    
}
