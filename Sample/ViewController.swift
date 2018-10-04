//
//  ViewController.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 20.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .lightGray
        NotificationCenter.post("event 1")
        NotificationCenter.post("event 2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Dispatch.main.after(1) {
            PinService.shared.show(for: .verify(supportsLogout: true), delegate: self)
        }
    }

}

extension ViewController: PinServiceDelegate {    
    
    func pinServicePinExists(_ service: PinService) -> Bool {
        return true
    }
    
    func pinService(_ service: PinService, verify pin: String, onFinish: (Bool) -> ()) {
        onFinish(pin == "111111")
    }
    
    func pinService(_ service: PinService, didChangePin newPin: String) {
        
    }
    
    func pinService(_ service: PinService, didEnter passcode: String) {
        
    }
    
    func pinServiceDidRequestLogout(_ service: PinService) {
        PinService.shared.hide()
    }
    
    func pinServiceDidCancel(_ service: PinService) {
        
    }
    
}
