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
        localItem.setAttributedTitle(Localization.Menu.local)
        remoteItem.setAttributedTitle(Localization.Menu.remote)
        downloadItem.setAttributedTitle(Localization.Menu.remoteDownload)
        configItem.setAttributedTitle(Localization.Menu.remoteConfig)
        helpItem.setAttributedTitle(Localization.Menu.help)
        checkItem.setAttributedTitle(Localization.Menu.helpCheck)
        aboutItem.setAttributedTitle(Localization.Menu.helpAbout)
        quitItem.setAttributedTitle(Localization.Menu.quit)
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
