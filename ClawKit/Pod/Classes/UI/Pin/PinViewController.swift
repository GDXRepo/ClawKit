//
//  PinViewController.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 12.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

public protocol PinViewControllerDelegate {
    
    func pinController(_ controller: PinViewController, didPressDigit digit: Int)
    func pinControllerDidErase(_ controller: PinViewController)
    func pinControllerDidPressBiometrics(_ controller: PinViewController)
    func pinControllerDidPressClose(_ controller: PinViewController)
    func pinControllerDidPressLogout(_ controller: PinViewController)
    
}

public class PinViewController: UIViewController {
    
    enum DotsState {
        case `default`
        case valid
        case invalid
    }
    
    var delegate: PinViewControllerDelegate?
    private var isInteractible: Bool = true {
        didSet {
            view.isUserInteractionEnabled = isInteractible
        }
    }
    public var header: String? {
        didSet {
            headerLabel.text = header
        }
    }
    public var prompt: String? = "ClawKit.pin.prompt".loc() {
        didSet {
            promptLabel.text = prompt
        }
    }
    public var hint: String? {
        didSet {
            view.setNeedsUpdateConstraints()
            view.setNeedsLayout()
            hintLabel.text = hint
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.view.updateConstraints()
                self?.view.layoutSubviews()
            }
        }
    }
    var dotsFilled = 0 {
        didSet {
            var string = ""
            for i in 0..<PinService.shared.digitsCount {
                string += (i < dotsFilled) ? "●" : "○"
                string += "     "
            }
            dotsLabel.text = string.trimmingCharacters(in: .whitespaces)
        }
    }
    var dotsState: DotsState = .default {
        didSet {
            switch dotsState {
            case .default:
                isInteractible = true
                dotsLabel.textColor = appearance.dotsColor
            case .valid:
                isInteractible = false
                dotsLabel.textColor = appearance.utilityColors.valid
            case .invalid:
                isInteractible = false
                dotsLabel.textColor = appearance.utilityColors.invalid
            }
        }
    }
    let appearance: PinAppearance
    private let multiplier = UIScreen.main.bounds.width / 320
    private var contentView: UIView!
    private var headerLabel: UILabel!
    private var closeButton: UIButton!
    private var promptLabel: UILabel!
    private var hintLabel: UILabel!
    private var dotsLabel: UILabel!
    private var collectionView: UICollectionView!
    private var logoutButton: UIButton!
    
    public init(appearance: PinAppearance) {
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        assert(false)
        return nil
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: appearance.blurStyle))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        contentView = UIView(frame: .zero)
        contentView.backgroundColor = .clear
        view.addSubview(contentView)
        
        headerLabel = UILabel(frame: .zero)
        headerLabel.textAlignment = .center
        headerLabel.font = appearance.headerFont
        headerLabel.isHidden = true // hide, looks pretty bad on the iPhones without notch
        view.addSubview(headerLabel)
        
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "close-button"), for: .normal)
        closeButton.addTarget(self, action: #selector(_handleClose), for: .touchUpInside)
        view.addSubview(closeButton)
        
        promptLabel = UILabel(frame: .zero)
        promptLabel.textAlignment = .center
        promptLabel.font = appearance.promptFont
        contentView.addSubview(promptLabel)
        
        hintLabel = UILabel(frame: .zero)
        hintLabel.font = appearance.hintFont
        hintLabel.numberOfLines = 2
        hintLabel.textAlignment = promptLabel.textAlignment
        hintLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(hintLabel)
        
        dotsLabel = UILabel(frame: .zero)
        dotsLabel.font = appearance.dotsFont
        dotsLabel.textAlignment = hintLabel.textAlignment
        contentView.addSubview(dotsLabel)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset.left = 3 * multiplier
        flowLayout.sectionInset.top = 2 * multiplier
        flowLayout.sectionInset.right = 3 * multiplier
        flowLayout.estimatedItemSize = CGSize(width: 60, height: 60)
        flowLayout.minimumLineSpacing = 14 * multiplier
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(PinButtonCollectionCell.self, forCellWithReuseIdentifier: "CellId")
        contentView.addSubview(collectionView)
        
        logoutButton = UIButton(type: .system)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        logoutButton.setTitleColor(.gray, for: .normal)
        logoutButton.addTarget(self, action: #selector(_handleLogout), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    override public func updateViewConstraints() {
        headerLabel.snp.updateConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.centerX.equalTo(contentView)
        }
        closeButton.snp.updateConstraints { (make) in
            make.centerY.equalTo(headerLabel)
            make.width.height.equalTo(44)
            make.left.equalTo(view.snp.leftMargin)
        }
        promptLabel.snp.updateConstraints { (make) in
            make.top.equalTo(16)
            make.centerX.equalTo(headerLabel)
            make.bottom.equalTo(hintLabel.snp.top).offset(-4 * multiplier)
        }
        hintLabel.snp.updateConstraints { (make) in
            make.left.equalTo(84 * multiplier)
            make.right.equalTo(-84 * multiplier)
            make.bottom.equalTo(dotsLabel.snp.top).offset(-11 * multiplier)
        }
        dotsLabel.snp.updateConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(collectionView.snp.top).offset(-41 * multiplier)
        }
        contentView.snp.updateConstraints { (make) in
            make.left.right.equalTo(0)
            make.centerY.equalTo(view).offset(-22)
        }
        collectionView.snp.updateConstraints { (make) in
            make.left.equalTo(40 * multiplier)
            make.right.equalTo(-40 * multiplier)
            make.bottom.equalTo(-10 * multiplier)
            make.height.equalTo(297 * multiplier)
        }
        logoutButton.snp.updateConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(100)
        }
        super.updateViewConstraints()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerLabel.textColor = appearance.headerColor
        headerLabel.text = header
        switch PinService.shared.mode {
        case .get:
            closeButton.isHidden = false
            logoutButton.isHidden = true
        case .verify(let supportsLogout):
            closeButton.isHidden = true
            logoutButton.isHidden = !supportsLogout
        case .change(let supportsLogout):
            closeButton.isHidden = false
            logoutButton.isHidden = !supportsLogout
        }
        promptLabel.textColor = appearance.promptColor
        promptLabel.text = prompt
        hintLabel.textColor = appearance.hintColor
        hintLabel.text = hint
        dotsLabel.textColor = appearance.dotsColor
        logoutButton.setTitle(appearance.logoutTitle, for: .normal)
    }
    
}

// MARK: - Handlers

extension PinViewController {
    
    private func _handleClick(on buttonType: PinButtonControl.ButtonType) {
        switch buttonType {
        case .digit(let value):
            delegate?.pinController(self, didPressDigit: Int(value))
        case .erase:
            delegate?.pinControllerDidErase(self)
        case .touchId:
            delegate?.pinControllerDidPressBiometrics(self)
        case .empty:
            break
        }
    }
    
    @objc private func _handleClose() {
        delegate?.pinControllerDidPressClose(self)
    }
    
    @objc private func _handleLogout() {
        delegate?.pinControllerDidPressLogout(self)
    }
    
}

// MARK: - Utils

extension PinViewController {
    
    func animateError(hint: String? = nil, completion: (() -> ())? = nil) {
        if hint != nil {
            self.hint = hint
        }
        isInteractible = false // deny touches
        dotsState = .invalid
        // shake animation (wait a bit before it, its necessary to take time for hint label layout)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [unowned self] in
            let animation = CABasicAnimation(keyPath: "position")
            animation.isRemovedOnCompletion = true
            animation.duration = 0.07
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = CGPoint(x: self.dotsLabel.center.x - 8, y: self.dotsLabel.center.y)
            animation.toValue = CGPoint(x: self.dotsLabel.center.x + 8, y: self.dotsLabel.center.y)
            self.dotsLabel.layer.add(animation, forKey: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dotsState = .default
                self.isInteractible = true // allow touches
                completion?()
            }
        }
    }
    
    func animateSlide(hint: String? = nil, completion: (() -> ())? = nil) {
        if hint != nil {
            self.hint = hint
        }
        isInteractible = false // deny touches
        let duration = 0.15
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [unowned self] in
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    self.dotsLabel.frame.origin.x = -self.dotsLabel.frame.size.width
            }) { (finished) in
                self.dotsLabel.frame.origin.x = self.view.bounds.width + self.dotsLabel.frame.size.width
                self.dotsState = .default // reset dots state to prevent extra colorizing
                // sliding in
                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: {
                        self.dotsLabel.center.x = self.view.center.x
                }) { [unowned self] (finished) in
                    self.isInteractible = true // allow touches
                    completion?()
                }
            }
        }
    }
    
}

extension PinViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let id = "CellId"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! PinButtonCollectionCell
        switch indexPath.item {
        case 9: // TouchID
            if case .verify(_) = PinService.shared.mode { // can be displayed only when verifying, not changing
                var error: NSError?
                if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    cell.type = PinService.shared.isAllowBiometrics ? .touchId : .empty
                } else {
                    cell.type = .empty
                }
            } else {
                cell.type = .empty
            }
        case 10: // zero digit
            cell.type = .digit(value: 0)
        case 11: // erase button
            cell.type = .erase
        default: // other digits
            cell.type = .digit(value: UInt(indexPath.row + 1))
        }
        cell.onClick = { [weak self] type in
            self?._handleClick(on: type)
        }
        return cell
    }
    
}
