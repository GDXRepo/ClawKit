//
//  UIFactory.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 10.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

open class UIFactory {
    
    private init() {
        // empty
    }
    
}

// MARK: - Buttons

public extension UIFactory {
    
    public class func button(superview: UIView?) -> CKButton {
        let button = CKButton(frame: .zero)
        button.titleLabel?.font = FontManager.font(size: 16)
        button.setTitleColor(.black, for: .normal)
        return button.added(to: superview) as! CKButton
    }
    
    public class func button(imageNamed name: String, superview: UIView?) -> CKButton {
        let button = CKButton(frame: .zero)
        button.setImage(UIImage(named: name), for: .normal)
        return button.added(to: superview) as! CKButton
    }
    
    public class func button(font: UIFont, titleColor: UIColor, superview: UIView?) -> CKButton {
        let button = CKButton(frame: .zero)
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        return button.added(to: superview) as! CKButton
    }
    
}

// MARK: - Others
    
public extension UIFactory {
    
    public class func label(font: UIFont = FontManager.font(size: 15, weight: .light), textColor: UIColor = .black, textAlignment: NSTextAlignment = .center, wordWrap: Bool = true, superview: UIView?) -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = font
        label.textColor = textColor
        label.numberOfLines = wordWrap ? 0 : 1
        label.lineBreakMode = wordWrap ? .byWordWrapping : .byTruncatingTail
        label.textAlignment = textAlignment
        return label.added(to: superview) as! UILabel
    }
    
    public class func imageView(with imageNamed: String? = nil, contentMode: UIViewContentMode = .scaleAspectFit, superview: UIView?) -> UIImageView {
        let imageView = UIImageView(image: (imageNamed != nil) ? UIImage(named: imageNamed!) : nil)
        imageView.contentMode = contentMode
        return imageView.added(to: superview) as! UIImageView
    }
    
    public class func imageView(with image: UIImage?, contentMode: UIViewContentMode = .scaleAspectFit, superview: UIView?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        return imageView.added(to: superview) as! UIImageView
    }
    
    public class func view(color: UIColor = .white, alpha: CGFloat = 1.0, cornerRadius: UInt = 0, superview: UIView?) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = color
        view.alpha = alpha
        view.clipsToBounds = (cornerRadius != 0)
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view.added(to: superview)
    }
    
    public class func stackView(distribution: UIStackViewDistribution = .fillEqually, axis: UILayoutConstraintAxis = .horizontal, cornerRadius: UInt = 0, superview: UIView?) -> UIStackView {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = (cornerRadius != 0)
        view.distribution = distribution
        view.axis = axis
        return view.added(to: superview) as! UIStackView
    }
    
}

extension UIView {
    
    fileprivate func added(to: UIView?) -> UIView {
        to?.addSubview(self)
        return self
    }
    
}
