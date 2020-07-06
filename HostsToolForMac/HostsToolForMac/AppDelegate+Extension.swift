//
//  AppDelegate+Extension.swift
//  HostsToolForMac
//
//  Created by zm on 2019/11/14.
//  Copyright © 2019 ZzzM. All rights reserved.
//


import Cocoa

extension AppDelegate: NSUserNotificationCenterDelegate {

    func setupBarItem(_ barItem: NSStatusItem) {
        
        updater.automaticallyChecksForUpdates = false
        
        let itemIcon = #imageLiteral(resourceName: "AppIcon_s")
        itemIcon.isTemplate = true
        barItem.image = itemIcon
        barItem.menu = menu
    }
    
    
    func setupNotification(){
        NSUserNotificationCenter.default.delegate = self
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

}
