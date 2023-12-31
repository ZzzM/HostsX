//
//  AppDelegate.swift
//  HostsX
//
//  Created by zm on 2021/12/2.
//

import Cocoa


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private lazy var statusItem = NSStatusItem.system


    @IBOutlet weak var menu: AppMenu!


    func applicationWillFinishLaunching(_ notification: Notification) {
        check()
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {

        statusItem.setMenuBarIcon()
        statusItem.menu = menu

    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

extension AppDelegate {
    private func check() {
        let id = Bundle.main.identifier
        NSRunningApplication
            .runningApplications(withBundleIdentifier: id)
            .filter(\.isFinishedLaunching)
            .forEach { $0.terminate() }
    }
}
