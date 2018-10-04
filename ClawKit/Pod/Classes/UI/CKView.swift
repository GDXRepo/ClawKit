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
    
    public convenience init(superview: UIView?) {
        self.init(frame: .zero)
        superview?.addSubview(self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        preload()
        make()
        bind()
        localize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        assert(false)
        return nil
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }
    
    // MARK: - UIReloadable
    
    open func preload() {
        // empty
    }
    
    open func make() {
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
