//
//  AppMenu.swift
//  HostsX
//
//  Created by zm on 2021/12/17.
//

import Cocoa

class AppMenu: NSMenu {

    @IBOutlet weak var localItem: NSMenuItem!

    @IBOutlet weak var remoteItem: NSMenuItem!
    @IBOutlet weak var downloadItem: NSMenuItem!
    @IBOutlet weak var configItem: NSMenuItem!

    @IBOutlet weak var helpItem: NSMenuItem!
    @IBOutlet weak var checkItem: NSMenuItem!
    @IBOutlet weak var aboutItem: NSMenuItem!

    @IBOutlet weak var quitItem: NSMenuItem!

    private var wc: NSWindowController?
    
    override func awakeFromNib() {
        localItem.title = Localization.Menu.local
        remoteItem.title = Localization.Menu.remote
        downloadItem.title = Localization.Menu.remoteDownload
        configItem.title = Localization.Menu.remoteConfig
        helpItem.title = Localization.Menu.help
        checkItem.title = Localization.Menu.helpCheck
        aboutItem.title = Localization.Menu.helpAbout
        quitItem.title = Localization.Menu.quit
    }

    @IBAction func onLoacl(_ sender: NSMenuItem) {
        FileHelper.localUpdate {
            NotificationHelper.deliver(category: .loacl, error: $0)
        }
    }

    
    @IBAction func onDownload(_ sender: NSMenuItem) {
        sender.isEnabled.toggle()
        FileHelper.remoteUpdate {
            sender.isEnabled.toggle()
            NotificationHelper.deliver(category: .remote, error: $0)
        }
    }

    @IBAction func onConfigure(_ sender: Any) {
        wc.show(.remote)
    }


    @IBAction func onAbout(_ sender: Any) {
        wc.show(.help)
    }
    
}
