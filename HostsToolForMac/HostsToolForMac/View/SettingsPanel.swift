//
//  SettingsView.swift
//  HostsToolForMac
//
//  Created by zm on 2019/12/31.
//  Copyright © 2019 ZzzM. All rights reserved.
//

import Cocoa

class SettingsPanel: NSPanel {
    
    @IBOutlet weak var optionsLabel: NSTextField!
    @IBOutlet weak var optionsButton: NSPopUpButton!
    
    @IBOutlet weak var lookButton: NSButton!
    

    
    var hostsType: HostsType! {
        return optionsButton.selectedItem?.title.hostsType
    }
    
    
    override func awakeFromNib() {

        title =  AppName

        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        
        optionsLabel.stringValue = "Settings.Title.Hosts".localized
        optionsButton.addItems(withTitles: HostsType.names)
        optionsButton.selectItem(withTitle: HostsType.current.name)
        optionsButton.menu?.delegate = self
        
        lookButton.title = "Settings.Title.View".localized
        
    }
    
    @IBAction func lookAction(_ sender: Any) {
        hostsType.url.open()
    }
    
    static func show() {
        
        if !NSApp.isActive {
            NSApp.activate(ignoringOtherApps: true)
        }
        
        let panel = SettingsPanel.loadFromNib()
        NSApp.runModal(for: panel)

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

