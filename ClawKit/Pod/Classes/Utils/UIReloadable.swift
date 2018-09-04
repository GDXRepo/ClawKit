//
//  UIReloadable.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 30.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public protocol UIReloadable: UIConfigurable {
    
    /// Reloads data using current view's state.
    func reloadData()
    
}
