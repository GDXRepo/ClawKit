//
//  UIConfigurable.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 26.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
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
