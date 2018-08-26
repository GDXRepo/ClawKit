//
//  Button.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 10.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

open class Button: UIButton {
    
    public var text: String? {
        didSet {
            setTitle(text, for: .normal)
        }
    }
    public var onClick: ((UIButton) -> ())? {
        didSet {
            addTarget(self, action: #selector(_handleOnClick), for: .touchUpInside)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        assert(false)
        return nil
    }
    
}

extension Button {
    
    @objc private func _handleOnClick() {
        onClick?(self)
    }
    
}
