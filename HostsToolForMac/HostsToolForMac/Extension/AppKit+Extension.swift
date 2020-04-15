
//
//  AppKit+Extension.swift
//  HostsToolForMac
//
//  Created by zm on 2019/12/31.
//  Copyright © 2019 ZzzM. All rights reserved.
//

import Cocoa

extension NSView  {
    static func loadFromNib() -> Self {
        var objects: NSArray?
        Bundle.main.loadNibNamed(typeName,
                                 owner: .none,
                                 topLevelObjects: &objects)
        return objects?.first(where: {
            $0 is Self
        }) as! Self
    }
}

extension NSWindow  {
    static func loadFromNib() -> Self {
        var objects: NSArray?
        Bundle.main.loadNibNamed(typeName,
                                 owner: .none,
                                 topLevelObjects: &objects)
        return objects?.first(where: {
            $0 is Self
        }) as! Self
    }
}
