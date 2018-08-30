//
//  CKView.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 26.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

open class CKView: UIView, UIReloadable {
    
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
    
    // MARK: - UIReloadable
    
    open func setup() {
        // empty
    }
    
    open func bind() {
        // empty
    }
    
    open func localize() {
        // empty
    }
    
    open func reloadData() {
        setNeedsUpdateConstraints()
    }
    
}
