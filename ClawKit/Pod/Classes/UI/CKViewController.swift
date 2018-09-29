//
//  CKViewController.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 04.07.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit

open class CKViewController: UIViewController, UIReloadable {
    
    public private(set) var contentView: UIView!
    private var scrollView: UIScrollView!
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    
    /// Should be called in `viewWillAppear:` method. WARNING! Do not push a controller with navigation bar and transparent background on a controller without navigation bar. It will cause layout issues with disappearing controller.
    public var hidesNavigationBar: Bool = false {
        didSet {
            if navigationController?.isNavigationBarHidden != hidesNavigationBar {
                navigationController?.setNavigationBarHidden(hidesNavigationBar, animated: true)
                // workaround: fix layout after navigation bar changing
                view.performLayout(animated: false)
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // add gradient if necessary
        if let gradient = gradientBackground() {
            gradient.add(to: view)
        }
        // add content
        scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = .zero
        scrollView.keyboardDismissMode = .none
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        contentView = UIFactory.view(color: .clear, superview: scrollView)
        contentView.addGestureRecognizer(tapRecognizer) // hide keyboard on tapping the content view
        // setup UI
        preload()
        make()
        bind()
        localize()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.isScrollEnabled = allowsScrolling
        hidesNavigationBar = false
        updateViewConstraints() // workaround: necessary to perform valid layout
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.unsubscribe(self)
    }
    
    open override func updateViewConstraints() {
        scrollView.snp.updateConstraints { (make) in
            make.edges.equalTo(0)
        }
        contentView.snp.updateConstraints { (make) in
            make.edges.equalTo(0)
            make.width.equalTo(scrollView) // fixed width means that only vertical on-demand scroll is enabled
            make.height.greaterThanOrEqualTo(scrollView) // very important to prevent smaller height than screen size
        }
        super.updateViewConstraints()
    }
    
    @objc open var allowsScrolling: Bool {
        return true
    }
    
    /// Stores controller's current state.
    @objc open func saveState() {
        // empty
    }
    
    open func gradientBackground() -> Gradient? {
        return nil
    }
    
    // MARK: - UIReloadable
    
    open func preload() {
        // empty
    }
    
    open func make() {
        // empty
    }
    
    open func bind() {
        // empty
    }
    
    open func localize() {
        // empty
    }
    
    open func reloadData() {
        // empty
    }
    
}

extension CKViewController {
    
    @objc public func hideKeyboard() {
        view.endEditing(true)
    }
    
    public func subscribe(selector: Selector, to notificationName: String) {
        NotificationCenter.subscribe(self, selector: selector, name: notificationName)
    }
    
}

// MARK: - Navigation

public extension CKViewController {
    
    public func push(_ controller: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    public func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: true)
    }
    
    public func present(_ controller: UIViewController, animated: Bool = true, callback: (() -> ())? = nil) {
        navigationController?.present(controller, animated: animated, completion: callback)
    }
    
    public func dismiss(animated: Bool = true, callback: (() -> ())? = nil) {
        navigationController?.dismiss(animated: animated, completion: callback)
    }
    
}
