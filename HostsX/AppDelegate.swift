//
//  AppDelegate.swift
//  HostsX
//
//  Created by zm on 2021/12/2.
//

import Cocoa


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusItem.system

    @IBOutlet weak var menu: AppMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        statusItem.setAttributedTitle(Bundle.main.bundleName)
        statusItem.menu = menu
        //RemoteSource.restore()
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

