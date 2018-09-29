//
//  PinButtonControl.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 12.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class PinButtonControl: UIControl {
    
    public enum ButtonType {
        case digit(value: UInt)
        case touchId
        case erase
        case empty
    }
    
    public let type: ButtonType
    public var onClick: ((PinButtonControl) -> ())?
    private let multiplier = UIScreen.main.bounds.size.width / 320
    private let colorDefault = UIColor.clear
    private let colorHighlighted: UIColor
    private var animator = UIViewPropertyAnimator()
    
    private var label: UILabel!
    private var imageView: UIImageView!
    
    init(type: ButtonType, highlightBackgroundColor: UIColor = .darkGray) {
        switch type {
        case .digit(let value):
            assert(value >= 0 && value < 10, "Invalid digit.")
            break
        default:
            break
        }
        self.type = type
        colorHighlighted = highlightBackgroundColor
        super.init(frame: .zero)
        // add border
        layer.borderColor = UIColor.gray.cgColor
        // UI
        label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 33)
        label.textColor = .white
        label.textAlignment = .center
        addSubview(label)
        
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        // add value
        _reset()
        // bindings
        addTarget(self, action: #selector(_touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(_touchUp), for: [.touchUpInside])
        addTarget(self, action: #selector(_touchUpCancel), for: [.touchDragExit, .touchCancel])
    }
    
    public required init?(coder aDecoder: NSCoder) {
        assert(false)
        return nil
    }
    
    public override func updateConstraints() {
        label.snp.updateConstraints { (make) in
            make.edges.equalTo(0)
            make.width.height.greaterThanOrEqualTo(60 * multiplier)
            make.aspectRatio(1, by: 1, self: label)
        }
        imageView.snp.updateConstraints { (make) in
            make.edges.equalTo(label)
        }
        super.updateConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width * 0.5
    }
    
}

extension PinButtonControl {
    
    @objc private func _touchDown() {
        switch type {
        case .empty:
            return
        default:
            break
        }
        animator.stopAnimation(true)
        backgroundColor = colorHighlighted
    }
    
    @objc private func _touchUp() {
        _touchUpCancel()
        onClick?(self) // then execute callback
    }
    
    @objc private func _touchUpCancel() {
        if case .empty = type {
            return
        }
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) { [weak self] in
            self?.backgroundColor = self?.colorDefault
        }
        animator.startAnimation()
    }
    
    private func _reset() {
        layer.borderWidth = 0
        label.text = nil
        imageView.image = nil
        // customize
        switch type {
        case .digit(let value):
            label.text = "\(value)"
            layer.borderWidth = 1
        case .touchId:
            imageView.image = UIImage(named: "button_touchId")
        case .erase:
            imageView.image = UIImage(named: "button_erase")
        case .empty:
            break
        }
    }
    
}

extension ConstraintMaker {
    
    public func aspectRatio(_ x: Int, by y: Int, self instance: ConstraintView) {
        self.width.equalTo(instance.snp.height).multipliedBy(x / y)
    }
    
}
