//
//  FontManager.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 11.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

public class FontManager {
    
    public static var defaultFontName = "SFUIDisplay"
    private(set) static var fonts = [String: UIFont]()
    
    private init () {
        // empty
    }
    
}

public extension FontManager {
    
    public class func font(size: Double, weight: UIFont.Weight = .medium) -> UIFont {
        var name: String = ""
        let id = _fontIdFor(size: size, weight: weight, resultName: &name)
        if let existing = fonts[id] {
            return existing
        }
        // make, save & return font
        let font = UIFont(name: name, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
        fonts[id] = font
        return font
    }
    
    private class func _fontIdFor(size: Double, weight: UIFont.Weight, resultName: inout String) -> String {
        var weightString: String
        switch weight {
        case .semibold:
            weightString = "Semibold"
        case .light:
            weightString = "Light"
        case .heavy:
            weightString = "Heavy"
        case .thin:
            weightString = "Thin"
        case .medium:
            weightString = "Medium"
        case .black:
            weightString = "Black"
        case .ultraLight:
            weightString = "UltraLight"
        case .bold:
            weightString = "Bold"
        default:
            weightString = "Regular"
        }
        resultName = "\(defaultFontName)-\(weightString)"
        return "\(resultName)-\(size)"
    }
    
}
