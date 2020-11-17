//
//  AppDelegate.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 01/03/2017.
//  Copyright © 2017 ZzzM. All rights reserved.
//

import Cocoa


@NSApplicationMain




class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupBarItem(statusItem)
        setupNotification()

        
    }

    
}

