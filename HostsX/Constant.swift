//
//  Constant.swift
//  HostsToolForMac
//
//  Created by zm on 2019/11/14.
//  Copyright © 2019 ZzzM. All rights reserved.
//

import Cocoa

typealias VoidClosure = () -> Void
typealias ReusltClosure = (String) -> Void
typealias HostsClosure = (String, String) -> Void
typealias FailureClosure = (Error?) -> Void
typealias RowClosure = (Int) -> Void



enum HostsPath {
    static let hosts = "/private/etc/hosts"
    static let temp = URL.temp.path
}


enum HostsTag {
    static let start = "# My Hosts Start"
    static let end = "# My Hosts End"
    static let flag = "###"
}

enum HostsUrl {
    static let h1 = "https://scaffrey.coding.net/p/hosts/d/hosts/git/raw/master/hosts-files/hosts"
    static let h2 = "https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts"
    static let github = "https://github.com/ZzzM/HostsX"
}

extension NSStatusItem {
    static let system = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
}


extension URL {
    static let temp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
}

extension NSSize {
    static let dialog = NSSize(width: 200, height: 120)
}

extension NSImage.Name {
    static let star = "star"
    static let add = "add"
    static let link = "link"
    static let trash = "trash"
}


extension NSStoryboard {
    static let remote = NSStoryboard(name: "Remote", bundle: .none)
    static let help = NSStoryboard(name: "Help", bundle: .none)
}

extension NSColor {
    @available(macOS 10.13, *)
    static let backgroud = NSColor(named: "backgroudColor")
}
