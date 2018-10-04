//
//  CKTableCell.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 18.09.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import UIKit

open class CKTableCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
