//
//  CKButton.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 10.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

open class CKButton: UIButton {
    
    public var text: String? {
        didSet {
            setTitle(text, for: .normal)
        }
    }
    public var onClick: ((CKButton) -> ())? {
        didSet {
            addTarget(self, action: #selector(_handleOnClick), for: .touchUpInside)
        }
    }
    public var isAnimated: Bool = true
    
    private var dimView: UIView!
    private var animator = UIViewPropertyAnimator()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // add dim view
        dimView = UIView(frame: bounds)
        dimView.alpha = 0
        dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimView.isExclusiveTouch = false
        dimView.backgroundColor = .black
        addSubview(dimView)
        // add handlers
        addTarget(self, action: #selector(_touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(_touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    public required init?(coder aDecoder: NSCoder) {
        assert(false)
        return nil
    }
    
}

extension CKButton {
    
    @objc private func _handleOnClick() {
        onClick?(self)
    }
        
    @objc private func _touchDown() {
        animator.stopAnimation(true)
        dimView.alpha = isAnimated ? 0.3 : 0 // this is the "alpha" parameter, not duration :)
    }
    
    @objc private func _touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) { [weak self] in
            self?.dimView.alpha = 0
        }
        animator.startAnimation()
    }
    
}
