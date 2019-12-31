//
//  String+Extension.swift
//  HostsToolForMac
//
//  Created by zm on 2019/11/10.
//  Copyright © 2019 ZzzM. All rights reserved.
//
import Cocoa

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var userInfo: [String : Any] { return (self as NSError).userInfo }
}

extension URL {
    func open() {
        NSWorkspace.shared.open(self)
    }
}
extension NSObject {
    var typeName: String {
        return "\(type(of: self))"
    }
    static var typeName: String {
        return "\(self)"
    }
}

extension DispatchQueue {
    static func mainAsync(_ execute:@escaping ()->()){
        main.async {
            execute()
        }
    }
    
    static func  globalAsync(_ execute:@escaping ()->()){
        global().async {
            execute()
        }
    }
}




