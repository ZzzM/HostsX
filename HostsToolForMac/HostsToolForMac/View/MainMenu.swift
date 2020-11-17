//
//  MainMenu.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/23.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa
import Sparkle

let updater = SUUpdater()

class MainMenu: NSMenu {

    @IBAction func importAction(_ sender: Any) {
        var result = ExecutionResult.invalid
        if let url = Helper.openPanel() {
            result = url.hosts.executed
        }
        Helper.deliverNotification(result.message)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        NSApp.open(DownloadPanel.self)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        NSApp.open(SettingsPanel.self)
    }
    
    @IBAction func checkAction(_ sender: Any) {
        updater.checkForUpdates(sender)
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

extension Data {
    var hosts: ExecutionResult {

        guard let _hosts = String(data: self, encoding: .utf8) else {
            return .invalid
        }
        
        return _hosts.verifyResult
    }
}
extension URL{
    var hosts: ExecutionResult {

        do {
            return try String(contentsOf: self).verifyResult
        } catch {
            
            guard let underlyingError = error.userInfo["NSUnderlyingError"] as? Error else {
                return .error(error.localizedDescription)
            }
            return .error(underlyingError.localizedDescription)
            
        }
    }

}
