//
//  UIFactory.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 10.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit
import MarqueeLabel

open class UIFactory {
    
    private init() {
        // empty
    }
    
}

// MARK: - Buttons

public extension UIFactory {
    
    public class func button(superview: UIView?) -> CKButton {
        let button = CKButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        return button.added(to: superview) as! CKButton
    }
    
    public class func button(imageNamed name: String, superview: UIView?) -> CKButton {
        let button = CKButton()
        button.setImage(UIImage(named: name), for: .normal)
        return button.added(to: superview) as! CKButton
    }
    
    public class func button(font: UIFont, titleColor: UIColor, superview: UIView?) -> CKButton {
        let button = CKButton()
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        return button.added(to: superview) as! CKButton
    }
    
}

// MARK: - Others
    
public extension UIFactory {
    
    public enum LabelWordWrap {
        case none
        case full
        case marquee
    }
    
    public class func label(
        font: UIFont,
        textColor: UIColor = .black,
        textAlignment: NSTextAlignment = .center,
        wordWrap: LabelWordWrap = .full,
        superview: UIView?
    ) -> UILabel {
        var label: UILabel!
        if wordWrap == .marquee {
            label = MarqueeLabel(frame: .zero, duration: 3, andFadeLength: 0)!
            (label as! MarqueeLabel).marqueeType = .MLLeftRight
            label.font = font
            label.textColor = textColor
            label.textAlignment = textAlignment
        } else {
            label = UILabel(frame: .zero)
            label.font = font
            label.textColor = textColor
            label.numberOfLines = (wordWrap == .full) ? 0 : 1
            label.lineBreakMode = (wordWrap == .full) ? .byWordWrapping : .byTruncatingTail
            label.textAlignment = textAlignment
        }
        return label.added(to: superview) as! UILabel
    }
    
    public class func imageView(
        with imageNamed: String? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        superview: UIView?
    ) -> UIImageView {
        let imageView = UIImageView(image: (imageNamed != nil) ? UIImage(named: imageNamed!) : nil)
        imageView.contentMode = contentMode
        return imageView.added(to: superview) as! UIImageView
    }
    
    public class func imageView(
        with image: UIImage?,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        superview: UIView?
    ) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        return imageView.added(to: superview) as! UIImageView
    }
    
    public class func view(
        color: UIColor = .white,
        alpha: CGFloat = 1.0,
        cornerRadius: UInt = 0,
        superview: UIView?
    ) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = color
        view.alpha = alpha
        view.clipsToBounds = (cornerRadius != 0)
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view.added(to: superview)
    }
    
    public class func tableView(
        style: UITableView.Style = .plain,
        backgroundColor: UIColor = .white,
        separatorStyle: UITableViewCell.SeparatorStyle = .none,
        separatorColor: UIColor? = .lightGray,
        isScrollable: Bool = true,
        superview: UIView?
    ) -> UITableView {
        let table = UITableView(frame: .zero, style: style)
        table.backgroundColor = backgroundColor
        table.separatorStyle = .none
        table.separatorColor = separatorColor
        table.isScrollEnabled = isScrollable
        return table.added(to: superview) as! UITableView
    }
    
    public class func stackView(
        distribution: UIStackView.Distribution = .fillEqually,
        axis: NSLayoutConstraint.Axis = .horizontal,
        cornerRadius: UInt = 0,
        superview: UIView?
    ) -> UIStackView {
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
