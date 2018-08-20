//
//  PinButtonCollectionCell.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 13.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

final class PinButtonCollectionCell: UICollectionViewCell {
    
    var type: PinButtonControl.ButtonType! {
        didSet {
            control?.removeFromSuperview()
            control = PinButtonControl(type: type)
            control!.onClick = { [weak self] control in
                self?._handleClick(on: control)
            }
            addSubview(control!)
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }
    var onClick: ((PinButtonControl.ButtonType) -> ())? {
        didSet {
            control?.onClick = { [weak self] control in
                self?._handleClick(on: control)
            }
        }
    }
    private var control: PinButtonControl?
    
    override func updateConstraints() {
        control?.snp.updateConstraints { (make) in
            make.edges.equalTo(0)
        }
        super.updateConstraints()
    }
    
}

extension PinButtonCollectionCell {
    
    private func _handleClick(on control: PinButtonControl) {
        onClick?(control.type)
    }
    
}
