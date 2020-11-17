//
//  SettingsView.swift
//  HostsToolForMac
//
//  Created by zm on 2019/12/31.
//  Copyright © 2019 ZzzM. All rights reserved.
//

import Cocoa

class SettingsPanel: NSPanel {
    
    @IBOutlet weak var optionsButton: NSPopUpButton!
  

    var hostsType: HostsType! {
        return optionsButton.selectedItem?.title.hostsType
    }
    
    override func awakeFromNib() {

        optionsButton.addItems(withTitles: HostsType.names)
        optionsButton.selectItem(withTitle: HostsType.current.name)
        optionsButton.menu?.delegate = self
        
    }
    
    @IBAction func lookAction(_ sender: Any) {
        hostsType.url.open()
    }
    
    @IBAction func close(_ sender: Any) {
        close()
    }

    
}

extension SettingsPanel: NSMenuDelegate {

    func menuDidClose(_ menu: NSMenu) {
        HostsType.current = hostsType
    }
    
}

extension SettingsPanel: NSWindowDelegate {
    override func close() {
        super.close()
        NSApp.abortModal()
    }
}

