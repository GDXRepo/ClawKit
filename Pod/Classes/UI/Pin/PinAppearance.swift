//
//  PinAppearance.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 17.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import UIKit

public protocol PinAppearance {
    
    var blurStyle: UIBlurEffectStyle { get }
    
    var headerColor: UIColor { get }
    var promptColor: UIColor { get }
    var hintColor: UIColor { get }
    var dotsColor: UIColor { get }
    var utilityColors: (valid: UIColor, invalid: UIColor) { get }
    
    var headerFont: UIFont { get }
    var promptFont: UIFont { get }
    var hintFont: UIFont { get }
    var dotsFont: UIFont { get }
    
    var logoutTitle: String? { get }
    
}

public final class PinDefaultAppearance: PinAppearance {
    
    public var blurStyle: UIBlurEffectStyle = .dark
    
    public var headerColor: UIColor = .white
    
    public var promptColor: UIColor = .white
    
    public var hintColor: UIColor = .white
    
    public var dotsColor: UIColor = .white
    
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
