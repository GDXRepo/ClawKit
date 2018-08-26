//
//  CKView.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 26.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

class CKView: UIView, UIConfigurable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bind()
        localize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        assert(false)
        return nil
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
