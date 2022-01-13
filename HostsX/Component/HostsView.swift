//
//  HostsView.swift
//  HostsX
//
//  Created by zm on 2021/12/23.
//

import Cocoa

class HostsView: NSView {

    override func updateLayer() {
        if #available(macOS 10.13, *) {
            self.layer?.backgroundColor = NSColor.backgroud?.cgColor
        } else {
            // Fallback on earlier versions
        }
    }
    
}
