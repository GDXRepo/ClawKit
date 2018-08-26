//
//  UILabel+Empty.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 09.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import UIKit

public extension UILabel {
    
    public var isEmpty: Bool {
        return text == nil || (text != nil && text!.isEmpty)
    }
    
}
