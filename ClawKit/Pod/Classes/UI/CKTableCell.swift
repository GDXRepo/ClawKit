//
//  CKTableCell.swift
//  Worldcore
//
//  Created by Георгий Малюков on 18.09.2018.
//  Copyright © 2018 EUPSprovider s.r.o. All rights reserved.
//

import UIKit

open class CKTableCell: UITableViewCell {
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        make()
        bind()
        localize()
        updateConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

extension CKTableCell: UIConfigurable {
    
    open func preload() {
        // empty
    }
    
    open func make() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    open func bind() {
        // empty
    }
    
    open func localize() {
        // empty
    }
    
}
