//
//  Keychain.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 13.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation
import SAMKeychain

public final class Keychain {
    
    public static var account: String!
    
    private init() {
        // empty
    }
    
    public static func get(_ key: String) -> String? {
        return SAMKeychain.password(forService: key, account: account)
    }
    
    public static func set(_ value: CustomStringConvertible?, for key: String) {
        if let string = value?.description {
            SAMKeychain.setPassword(string, forService: key, account: account)
        } else {
            SAMKeychain.deletePassword(forService: key, account: account)
        }
    }
    
    public static func remove(_ key: String) {
        set(nil, for: key)
    }
    
}
