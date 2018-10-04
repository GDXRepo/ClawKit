//
//  PinAppearance.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 17.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import UIKit

public protocol PinAppearance {
    
    var blurStyle: UIBlurEffect.Style { get set }
    
    var headerColor: UIColor { get set }
    var promptColor: UIColor { get set }
    var hintColor: UIColor { get set }
    var dotsColor: UIColor { get set }
    var highlightingColor: UIColor { get set }
    var utilityColors: (valid: UIColor, invalid: UIColor) { get set }
    
    var headerFont: UIFont { get set }
    var promptFont: UIFont { get set }
    var hintFont: UIFont { get set }
    var dotsFont: UIFont { get set }
    
    var logoutTitle: String? { get set }
    
}

public final class PinDefaultAppearance: PinAppearance {
    
    public var blurStyle: UIBlurEffect.Style = .dark
    
    public var headerColor: UIColor = .white
    
    public var promptColor: UIColor = .white
    
    public var hintColor: UIColor = .white
    
    public var dotsColor: UIColor = .white
    
    public var highlightingColor: UIColor = .darkGray
    
    public var utilityColors: (valid: UIColor, invalid: UIColor) = (UIColor(hex: 0x00c4c2), UIColor(hex: 0xf44650))
    
    public var headerFont: UIFont = .systemFont(ofSize: 21, weight: .medium)
    
    public var promptFont: UIFont = .systemFont(ofSize: 21)
    
    public var hintFont: UIFont = .systemFont(ofSize: 14)
    
    public var dotsFont: UIFont = .systemFont(ofSize: 16)
    
    public var logoutTitle: String? = "ClawKit.pin.logout.title".loc()
    
    public init() {
        // empty
    }
    
}
