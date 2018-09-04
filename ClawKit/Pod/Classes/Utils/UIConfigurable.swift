//
//  UIConfigurable.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 26.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public protocol UIConfigurable: class {
    
    /// Performs initial view's state setup.
    func preload()
    
    /// Creates the UI elements.
    func make()
    
    /// Binds UI actions.
    func bind()
    
    /// Localizes subviews.
    func localize()
    
}
