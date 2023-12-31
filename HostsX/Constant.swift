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
typealias SourceClosure = (Source) -> Void
typealias FailureClosure = (Error?) -> Void
typealias RowClosure = (Int) -> Void

extension URL {

    static var temporary: URL {
        let directory = FileManager.default.temporaryDirectory
        if #available(macOS 13.0, *) {
            return directory.appending(components: Bundle.main.identifier)
        } else {
            return directory.appendingPathComponent(Bundle.main.identifier)
        }
    }

    static var tmpHosts: URL {
        let component = "hosts_tmp"
        if #available(macOS 13.0, *) {
            return temporary.appending(component: component)
        } else {
            return temporary.appendingPathComponent(component)
        }
    }


}


enum HXPath {

    static let hosts = "/private/etc/hosts"
    static let oldHosts = "/private/etc/hosts_old"

    static var temporary: String {
        if #available(macOS 13.0, *) {
            return URL.temporary.path()
        } else {
            return URL.temporary.path
        }
    }
    static var tmpHosts: String {
        if #available(macOS 13.0, *) {
            return URL.tmpHosts.path()
        } else {
            return URL.tmpHosts.path
        }
    }
}


enum HXTag {
    static let start = "# My Hosts Start"
    static let end = "# My Hosts End"
    static let flag = "###"
}

enum HXURL {
    static let test = ""
    static let github = "https://github.com/ZzzM/HostsX"
}

extension NSStatusItem {
    static let system = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
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

//extension NSImage {
//    static let star = NSImage(named: .star)
//    static let add = NSImage(named: .add)
//    static let link = NSImage(named: .link)
//    static let trash = NSImage(named: .trash)
//}


extension NSStoryboard {
    static let remote = NSStoryboard(name: "Remote", bundle: .none)
    static let about = NSStoryboard(name: "About", bundle: .none)
}


extension NSColor {
    static let background = NSColor(named: "background")!
    static let cellBackground = NSColor(named: "cellBackground")!
}
