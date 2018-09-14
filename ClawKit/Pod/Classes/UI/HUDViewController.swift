//
//  HUDViewController.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 08.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

public typealias HUD = HUDViewController

public final class HUDViewController: CKViewController {
    
    public var data: (title: String?, subtitle: String?) {
        didSet {
            if titleLabel != nil {
                titleLabel.text = data.title
                subtitleLabel.text = data.subtitle
                view.performLayout()
            }
        }
    }
    private let animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Double.pi * 2.0
        animation.duration = 2.5
        animation.isCumulative = true
        animation.repeatCount = HUGE
        return animation
    }()
    private var backgroundView: UIView!
    private var borderView: UIView!
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView = UIFactory.view(color: .black, alpha: 0.2, superview: contentView)
        
        borderView = UIFactory.view(color: .black, cornerRadius: 4, superview: contentView)
        imageView = UIFactory.imageView(with: "loading", contentMode: .center, superview: borderView)
        
        titleLabel = UIFactory.label(
            font: UIFont.systemFont(ofSize: 17, weight: .medium),
            textColor: .white,
            superview: borderView
        )
        titleLabel.text = data.title
        
        subtitleLabel = UIFactory.label(
            font: UIFont.systemFont(ofSize: 15, weight: .light),
            textColor: titleLabel.textColor,
            superview: titleLabel.superview
        )
        subtitleLabel.text = data.subtitle
    }
    
    public override func updateViewConstraints() {
        backgroundView.snp.updateConstraints { (make) in
            make.edges.equalTo(0)
        }
        // border view
        borderView.snp.updateConstraints { (make) in
            make.center.equalTo(view)
            make.left.greaterThanOrEqualTo(50)
            make.right.lessThanOrEqualTo(-50)
        }
        imageView.snp.updateConstraints { (make) in
            make.centerX.equalTo(borderView)
            make.top.equalTo(15)
            make.left.greaterThanOrEqualTo(15)
            make.right.lessThanOrEqualTo(-15)
            make.width.height.equalTo(48)
            make.bottom.lessThanOrEqualTo(-15)
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            if !titleLabel.isEmpty {
                make.bottom.lessThanOrEqualTo(-15)
            }
        }
        subtitleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalTo(titleLabel)
            if !subtitleLabel.isEmpty {
                make.bottom.lessThanOrEqualTo(-15)
            }
        }
        super.updateViewConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.layer.add(animation, forKey: "rotationAnimation")
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.layer.removeAllAnimations()
    }
    
}

public extension HUDViewController {
    
    public static let shared = HUDViewController()
    private static var hudRefCount: UInt = 0
    
    public static func show(title: String? = nil, subtitle: String? = nil, keepValues: Bool = false) {
        DispatchQueue.main.async {
            hudRefCount += 1
            if keepValues {
                shared.data = (title ?? shared.data.title, subtitle ?? shared.data.subtitle)
            } else {
                shared.data = (title, subtitle)
            }
            if shared.view.superview == nil { // add only if not added yet
                shared.view.alpha = 0
                UIApplication.shared.keyWindow!.addSubview(shared.view)
                shared.view.performLayout(animated: false)
                UIView.animate(withDuration: 0.25) {
                    self.shared.view.alpha = 1
                }
            }
        }
    }
    
    public static func hide() {
        Dispatch.main.async {
            hudRefCount = (hudRefCount > 0) ? hudRefCount - 1 : 0
            if hudRefCount == 0 { // remove only there are no references remaining
                UIView.animate(
                    withDuration: 0.25,
                    animations: {
                        self.shared.view.alpha = 0
                    },
                    completion: { _ in
                        self.shared.view.removeFromSuperview()
                    }
                )
            }
        }
    }
    
    public func clear() {
        data = (nil, nil)
    }
    
}
