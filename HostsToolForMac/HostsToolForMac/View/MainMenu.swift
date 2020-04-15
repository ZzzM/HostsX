//
//  MainMenu.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/23.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa

class MainMenu: NSMenu {

    @IBOutlet weak var importItem: NSMenuItem!
    
    @IBOutlet weak var downloadItem: NSMenuItem!

    @IBOutlet weak var exitItem: NSMenuItem!
    
    @IBOutlet weak var settingsItem: NSMenuItem!
    @IBOutlet weak var homePageItem: NSMenuItem!
    
    override func awakeFromNib() {

        importItem.title = "Menu.Title.Import".localized
        downloadItem.title = "Menu.Title.Download".localized
        settingsItem.title = "Menu.Title.Settings".localized
        exitItem.title = "Menu.Title.Exit".localized
        homePageItem.title = "Menu.Title.HomePage".localized
    }

    @IBAction func importAction(_ sender: Any) {
        var result = ExecutionResult.invalid
        if let url = Helper.openPanel() {
            result = url.hosts.executed
        }
        Helper.deliverNotification(result.message)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        Helper.deliverNotification(HostsType.current.url
        .hosts
        .compared
        .executed
        .message)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        SettingsPanel.show()
    }
    
    @IBAction func homePageAction(_ sender: Any) {
        AppHomePageURL.open()
    }
    @IBAction func exitAction(_ sender: Any) {
        NSApp.terminate(.none)
    }
}

//MARK: Extension
extension String {
    var verifyResult: ExecutionResult {
        let condition = contains("localhost") && contains("127.0.0.1")
        return condition ?
            .success(self):
            .error("Error.Hosts.Invalid".localized)
    }
}

extension URL{
    var hosts: ExecutionResult {

        do {
            return try String(contentsOf: self).verifyResult
        } catch{
            
            guard let underlyingError = error.userInfo["NSUnderlyingError"] as? Error else {
                return .error(error.localizedDescription)
            }
            return .error(underlyingError.localizedDescription)
            
        }
    }

}
