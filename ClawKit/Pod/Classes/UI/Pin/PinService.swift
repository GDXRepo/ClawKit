//
//  PinService.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 15.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

public protocol PinServiceDelegate {
    
    /// Determines whether the PIN is already set and exists.
    func pinServicePinExists(_ service: PinService) -> Bool
    
    /// Verifies PIN and returns checking result.
    ///
    /// - Warning<br> If the `indeterminatedCheckingTime` flag is set to `true` then this method will execute in a separated queue.
    /// - Parameters:
    ///   - service: PIN service.
    ///   - pin: Passcode to check.
    ///   - onFinish: Verifying callback returning single parameter which indicates whether the passcode is valid.
    func pinService(_ service: PinService, verify pin: String, onFinish: (Bool) -> ())
    
    /// Destroys the PIN and removes it from the secured app's storage.
    func pinServiceDestroyPin(_ service: PinService)
    
    /// Informs about successful PIN change.
    ///
    /// - Parameters:
    ///   - service: PIN service.
    ///   - newPin: New PIN that must be stored the secured app's storage.
    func pinService(_ service: PinService, didChangePin newPin: String)
    
    /// Called when user requests logging out. You must hide PIN screen manually after finishing the process. See `hide()` for details.
    ///
    /// - Parameter service: PIN service.
    func pinServiceDidRequestLogout(_ service: PinService)
    
}

final public class PinService {
    
    public enum PinMode: Equatable {
        case change
        case verify(supportsLogout: Bool)
    }
    
    private enum ChangeState {
        case old
        case new(dontMatch: Bool)
        case confirm(passcode: String)
    }
    
    public static let shared = PinService()
    public private(set) var delegate: PinServiceDelegate!
    public private(set) var controller: PinViewController?
    public private(set) var mode: PinMode = .verify(supportsLogout: true)
    private let kAccount = "ClawKit.Keychain.PinService.Account"
    private let kRetriesRemaining = "RetriesRemaining"
    private var verifyingQueue = DispatchQueue.main
    private var state: ChangeState? {
        didSet {
            pin = nil
            if let state = state {
                controller!.header = "ClawKit.pin.header.change".loc()
                switch state {
                case .old:
                    controller!.hint = "ClawKit.pin.change.hint.old".loc()
                case .new(let dontMatch):
                    controller!.hint = (
                        dontMatch
                        ? "ClawKit.pin.change.hint.confirm.error".loc()
                        : "ClawKit.pin.change.hint.new".loc()
                    )
                case .confirm:
                    controller!.hint = "ClawKit.pin.change.hint.confirm".loc()
                }
            } else {
                controller!.header = nil
            }
        }
    }
    
    // MARK: - Customization
    
    public var digitsCount: Int = 6 {
        willSet {
            assert(newValue >= 4 && newValue <= 10, "Unsupported digits count.")
        }
    }
    public var maxRetryCount: UInt = 5 {
        willSet {
            assert(controller == nil, "Unable to change digits count while Pin controller is shown.")
        }
        didSet {
            reset() // reset retries remaining immediately
        }
    }
    public private(set) var retriesRemaining: UInt {
        get {
            if let value = Keychain.get(kRetriesRemaining), let uint = UInt(value) {
                return uint
            }
            // otherwise save max retry count as current retriesRemaining and return its value
            Keychain.set(maxRetryCount.description, for: kRetriesRemaining)
            return maxRetryCount
        }
        set {
            Keychain.set(newValue.description, for: kRetriesRemaining)
        }
    }
    /// Indicates whether the veryfing process can take a long time. If `true`, then HUD will be displayed until the process is complete. Default is `false`.
    public var indeterminatedCheckingTime: Bool = false {
        willSet {
            assert(controller == nil, "Unable to change value while Pin controller is shown.")
        }
        didSet {
            if indeterminatedCheckingTime {
                verifyingQueue = DispatchQueue(label: "ClawKit.PinService.pinValidation", qos: .userInitiated)
            } else {
                verifyingQueue = DispatchQueue.main
            }
        }
    }
    public var isAllowBiometrics = true {
        willSet {
            assert(controller == nil, "Unable to change value while Pin controller is shown.")
        }
    }
    public private(set) var pin: String? {
        willSet {
            if newValue != nil {
                assert(newValue!.count <= digitsCount, "Pin value exceeds maximum digits count.")
            }
        }
        didSet {
            controller?.dotsFilled = pin?.count ?? 0
        }
    }
    
    private init() {
        // empty
    }
    
}

extension PinService {
    
    /// Displays PIN screen.
    ///
    /// - Parameters:
    ///   - mode: Determines whether screen should be set up for verifying or changing passcode. Default is `.verify`.
    ///   - delegate: Delegate.
    ///   - appearance: UI appearance settings. Default is `PinDefaultAppearance()`.
    ///   - animated: Animated flag. Default is `true`.
    public func show(for mode: PinMode = .verify(supportsLogout: true), delegate: PinServiceDelegate, appearance: PinAppearance = PinDefaultAppearance(), animated: Bool = true) {
        guard controller == nil else {
            return
        }
        if case .verify(_) = mode {
            assert(delegate.pinServicePinExists(PinService.shared), "Pin must be set before verifying.")
            assert(retriesRemaining > 0, "The pin must already be destroyed in your app's storage due to exceeding retries limit. Please check the \"pinServiceDestroyPin()\" and \"pinServicePinExists()\" delegate methods for more information.")
        }
        self.mode = mode
        self.delegate = delegate
        // make controller
        controller = PinViewController(appearance: appearance)
        let ctrl = controller!
        _ = ctrl.view // prevents view lazy load
        ctrl.delegate = self
        // reset pin to display dots
        pin = nil
        // change state
        state = (mode == .change) ? .old : nil
        // display animated
        ctrl.view.isUserInteractionEnabled = false
        ctrl.view.alpha = 0
        ctrl.view.frame = UIScreen.main.bounds
        ctrl.updateViewConstraints()
        ctrl.viewWillAppear(true) // to perform UI customization
        UIApplication.shared.keyWindow!.addSubview(controller!.view)
        UIView.animate(withDuration: animated ? 0.25 : 0) { [unowned self] in
            ctrl.view.alpha = 1
            var error: NSError?
            if self.isAllowBiometrics && LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self._evaluateBiometrics()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // wait a bit to display TouchID/FaceID
                        ctrl.view.isUserInteractionEnabled = true
                    }
                }
            } else {
                ctrl.view.isUserInteractionEnabled = true
            }
        }
    }
    
    /// Hides the PIN screen.
    public func hide() {
        guard let ctrl = controller else {
            return
        }
        controller = nil // free immediately to prevent possible extra "hide()" calls
        UIView.animate(withDuration: 0.25, animations: {
            ctrl.view.alpha = 0
        }) { [weak self] _ in
            ctrl.view.removeFromSuperview()
            self?.pin = nil // destroy pin
        }
    }
    
    /// Resets retries remaining to maximum available value.
    public func reset() {
        retriesRemaining = maxRetryCount
    }
    
}

extension PinService {
    
    private func _handlePinEntered() {
        assert(pin != nil && pin!.count == digitsCount, "Invalid call.")
        let verificationHandler = { [unowned self] in
            if self.indeterminatedCheckingTime {
                UIApplication.hudShow()
            }
            self.verifyingQueue.async { // perform in the separated queue due to possibility of taking a long time
                self.delegate.pinService(self, verify: self.pin!) { isValid in
                    DispatchQueue.main.async {
                        if self.indeterminatedCheckingTime {
                            UIApplication.hudHide()
                        }
                        if isValid {
                            self._handleVerifyingSuccess()
                        } else {
                            self._handleVerifyingFailure()
                        }
                    }
                }
            }
        }
        if state != nil {
            switch state! {
            case .old:
                verificationHandler()
            case .new(_):
                _handleVerifyingSuccess()
            case .confirm(let passcode):
                _handlePinChange(with: passcode)
            }
        }
        else {
            verificationHandler()
        }
    }
    
    private func _handleVerifyingSuccess() {
        // disable interaction (there is no need to re-enable it later)
        controller?.view.isUserInteractionEnabled = false
        // reset retries count
        reset()
        // make green color
        switch mode {
        case .verify:
            controller?.dotsState = .valid
            // wait and hide
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.hide()
            }
        case .change:
            guard let s = state else {
                assert(false, "Invalid state.")
                return
            }
            switch s {
            case .old:
                controller?.animateSlide()
                state = .new(dontMatch: false)
            case .new(_):
                controller?.animateSlide()
                state = .confirm(passcode: pin!)
            case .confirm(_):
                assert(false, "Invalid case.")
            }
        }
    }
    
    private func _handleVerifyingFailure() {
        controller?.animateError() { [unowned self] in
            self.pin = nil
            if self.retriesRemaining > 1 {
                self.retriesRemaining -= 1
            } else {
                self.retriesRemaining = 0
                self.delegate.pinServiceDestroyPin(self)
                self.hide()
            }
        }
    }
    
    private func _handlePinChange(with passcode: String) {
        if pin! != passcode {
            controller?.dotsState = .invalid
            controller?.animateError()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35 ) { [weak self] in
                self?.controller?.animateSlide()
                self?.state = .new(dontMatch: true)
            }
        } else {
            controller?.dotsState = .valid
            // callback
            delegate.pinService(self, didChangePin: pin!)
            // hide self after a second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.hide()
            }
        }
    }
    
    private func _evaluateBiometrics() {
        pin = nil // reset pin to remove filled dots if they are exist
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "ClawKit.pin.biometrics".loc()) { (result, error) in
            DispatchQueue.main.async { [weak self] in // important for Face ID
//                self?.pin = "000000" // fill with something to display filled dots
                if error == nil {
                    self?.pin = "000000"
                    self?._handleVerifyingSuccess()
                } //else {
                    // do not decrease retries remaining when coming from biometrics, this flow is under iOS control
//                    self?._handleFailure()
//                }
            }
        }
    }
    
}

extension String {
    
    func loc() -> String {
        assert(count > 0, "Invalid tag length.")
        return NSLocalizedString(self, tableName: "ClawKitLocalizable", bundle: Bundle(for: PinService.self), comment: self)
    }
    
}

extension PinService: PinViewControllerDelegate {
    
    public func pinController(_ controller: PinViewController, didPressDigit digit: Int) {
        guard let p = pin else {
            pin = "\(digit)"
            return
        }
        if p.count < digitsCount { // and no action otherwise
            pin = "\(p)\(digit)"
            // check length immediately
            if pin!.count == digitsCount {
                _handlePinEntered()
            }
        }
    }
    
    public func pinControllerDidErase(_ controller: PinViewController) {
        guard let p = pin else {
            return
        }
        pin = (p.count == 1) ? nil : String(p[0..<(p.count - 1)]) // reduce by 1 symbol
    }
    
    public func pinControllerDidPressBiometrics(_ controller: PinViewController) {
        _evaluateBiometrics()
    }
    
    public func pinControllerDidPressClose(_ controller: PinViewController) {
        hide()
    }
    
    public func pinControllerDidPressLogout(_ controller: PinViewController) {
        let ctrl = UIAlertController(
            title: "ClawKit.pin.logout.title".loc(),
            message: "ClawKit.pin.logout.message".loc(),
            preferredStyle: .alert
        )
        let actionOK = UIAlertAction(title: "ClawKit.utils.ok".loc(), style: .default) { [unowned self] _ in
            self.delegate.pinServiceDidRequestLogout(self)
            ctrl.view.removeFromSuperview()
        }
        let actionCancel = UIAlertAction(title: "ClawKit.utils.cancel".loc(), style: .cancel) { _ in
            ctrl.dismiss(animated: true, completion: nil)
        }
        ctrl.addAction(actionOK)
        ctrl.addAction(actionCancel)
        controller.present(ctrl, animated: true)
    }
    
}
