//
//  HXView.swift
//  HostsX
//
//  Created by zm on 2021/12/23.
//

import Cocoa

class HXView: NSView {

    override func updateLayer() {
        self.layer?.backgroundColor = NSColor.background.cgColor
    }
    
}
