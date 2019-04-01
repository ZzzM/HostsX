//
//  MainMenu.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/23.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa


class MainMenu: NSMenu {


    @IBOutlet weak var importItem: NSMenuItem!
    
    @IBOutlet weak var networkItem: NSMenuItem!
    
    @IBOutlet weak var defaultItem: NSMenuItem!
    
    @IBOutlet weak var mirrorItem: NSMenuItem!
    
    @IBOutlet weak var checkItem: NSMenuItem!
    
    @IBOutlet weak var exitItem: NSMenuItem!
    
    
    override func awakeFromNib() {

        importItem.title = "Menu.Title.Import".localized()
        networkItem.title = "Menu.Title.Network".localized()
        
        defaultItem.title = "Submenu.Title.Default".localized()
        mirrorItem.title = "Submenu.Title.Mirror".localized()
        
        checkItem.title = "Menu.Title.Check".localized()
        exitItem.title = "Menu.Title.Exit".localized()
        
    }
    

    
    @IBAction func importAction(_ sender: Any) {
        
        _ = openPanel
            .execute
            .bind { deliverNotification($0.message) }

    }
    
    //MARK: Network Update
    
    @IBAction func defaultUpdateAction(_ sender: Any) {
        openURL(DefaultUpdateURL)
    }
    
    @IBAction func mirrorUpdateAction(_ sender: Any) {
        openURL(MirrorUpdateURL)
    }
    
    
    func openURL(_ url:URL) {
        _ = url
            .hosts
            .compare
            .execute
            .bind { deliverNotification($0.message) }

    }
    
    //MARK: Other

    @IBAction func appUpdateAction(_ sender: Any) {
        
        _ = Network
            .checkVersion
            .bind { deliverNotification($0.message) }

    }
    
    
    
    @IBAction func exitAction(_ sender: Any) {
        NSApp.terminate(nil)
    }
}
