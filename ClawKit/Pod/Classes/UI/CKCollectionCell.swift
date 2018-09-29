//
//  CKCollectionCell.swift
//  Worldcore
//
//  Created by Георгий Малюков on 22.09.2018.
//  Copyright © 2018 EUPSprovider s.r.o. All rights reserved.
//

import UIKit

open class CKCollectionCell: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        make()
        bind()
        localize()
        updateConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

extension CKCollectionCell: UIConfigurable {
    
    open func preload() {
        // empty
    }
    
    open func make() {
        backgroundColor = .clear
    }
    
    open func bind() {
        // empty
    }
    
    open func localize() {
        // empty
    }
    
}
