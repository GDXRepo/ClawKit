//
//  UIConfigurable.swift
//  Sample
//
//  Created by Георгий Малюков on 26.08.2018.
//  Copyright © 2018 GDXRepo. All rights reserved.
//

import Foundation

public protocol UIConfigurable: class {
    
    /// Sets up the UI elements.
    func setup()
    
    /// Binds UI actions.
    func bind()
    
    /// Localizes subviews.
    func localize()
    
}
