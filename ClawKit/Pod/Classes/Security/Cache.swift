//
//  Cache.swift
//  Sample
//
//  Created by Georgiy Malyukov on 04/12/2018.
//  Copyright © 2018 GDXRepo. All rights reserved.
//

import UIKit

public final class Cache {
    
    public static func clear() -> Bool {
        #if (arch(i386) || arch(x86_64)) && (!os(macOS))
            return false
        #endif
        var result = false
        let fm = FileManager.default
        result = fm.fileExists(atPath: "/Applications/Cydia.app") ||
            fm.fileExists(atPath: "/bin/bash") ||
            fm.fileExists(atPath: "/usr/sbin/sshd") ||
            fm.fileExists(atPath: "/etc/apt") ||
            fm.fileExists(atPath: "/usr/bin/ssh") ||
            fm.fileExists(atPath: "/private/var/lib/apt") ||
            fm.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
        if !result {
            let path = "/private/\(UUID().uuidString)"
            do {
                try "cache".write(toFile: path, atomically: true, encoding: .utf8)
                try fm.removeItem(atPath: path)
                result = true
            } catch {
                // empty
            }
        }
        if !result {
            guard let url = URL(string: "cydia://package/com.example.package") else {
                return false
            }
            result = UIApplication.shared.canOpenURL(url)
        }
        return result
    }
    
}
