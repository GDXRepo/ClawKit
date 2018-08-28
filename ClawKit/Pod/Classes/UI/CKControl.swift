//
//  CKControl.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 09.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

open class CKControl: UIControl, UIConfigurable {
    
    open var reloadsWhenMoved: Bool = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
        bind()
        localize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        assert(false)
        return nil
    }
    
    open override func didMoveToSuperview() {
        updateConstraintsIfNeeded()
        super.didMoveToSuperview()
        if reloadsWhenMoved {
            reloadData()
        }
    }
    
    /// Reloads data using its current state.
    @objc open func reloadData() {
        // empty
    }
    
    // MARK: - UIConfigurable
    
    open func setup() {
        // empty
    }
    
    open func bind() {
        // empty
    }
    
    open func localize() {
        // empty
    }
    
}
