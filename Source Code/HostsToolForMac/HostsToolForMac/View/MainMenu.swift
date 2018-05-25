//
//  MainMenu.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/23.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa
import RxSwift


class MainMenu: NSMenu {

    let disposeBag = DisposeBag()

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
        
        openPanel
            .filter{!$0.isEmpty}
            .execute()
            .subscribe(onNext: {
                Helper.showMessage($0)
            }, onError: {
                Helper.showMessage($0.localizedDescription)
            })
            .disposed(by: disposeBag)

    }
    
    //MARK: Network Update
    
    @IBAction func defaultUpdateAction(_ sender: Any) {
        openURL(DefaultUpdateURL)
    }
    
    @IBAction func mirrorUpdateAction(_ sender: Any) {
        openURL(MirrorUpdateURL)
    }
    
    
    func openURL(_ url:URL) {
        url
            .hosts
            .compare()
            .execute()
            .subscribe(onNext: {
                Helper.showMessage($0)
            }, onError: {
                Helper.showMessage($0.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Other

    @IBAction func appUpdateAction(_ sender: Any) {
        Network
            .checkVersion()
            .subscribe(onNext: {
                Helper.showMessage($0 ?
                    "Hint.Version.Latest".localized():
                    "Hint.Version.Availble".localized())
            }, onError: {
                Helper.showMessage($0.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    
    
    @IBAction func exitAction(_ sender: Any) {
        NSApplication.shared.terminate(nil)
    }
}
