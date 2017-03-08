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

    fileprivate let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    fileprivate let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.initHostsUpdateLink()
        self.initStatusItem()
    
    }

    fileprivate func initHostsUpdateLink(){
        if Utils.fetchCurrentHostsLink() == "" {
            Utils.saveCurrentHostsLink(link: Utils.kDefaultHostsLink)
        }
    }
    
    fileprivate func initStatusItem() {
        
        statusItem.button?.image = Utils.StatusIcon
        statusItem.target = self
        statusItem.action = #selector(statusItemClicked(sender:))
        
        popover.contentViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { (event) in
            if self.popover.isShown{self.popover.close()}
        }
    }
    
    @objc fileprivate func statusItemClicked(sender:NSButton) {
        if popover.isShown {
            popover.close()
        }else{
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge:.minY)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

