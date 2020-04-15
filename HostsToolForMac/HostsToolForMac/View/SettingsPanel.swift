//
//  SettingsView.swift
//  HostsToolForMac
//
//  Created by zm on 2019/12/31.
//  Copyright © 2019 ZzzM. All rights reserved.
//

import Cocoa

class SettingsPanel: NSPanel {
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    
    @IBOutlet weak var checkButton: NSButton!
    @IBOutlet weak var checkProgress: NSProgressIndicator!
    
    @IBOutlet weak var optionsLabel: NSTextField!
    @IBOutlet weak var optionsButton: NSPopUpButton!
    
    @IBOutlet weak var lookButton: NSButton!
    
    var versionStatus: VersionStatus? {
        didSet {
            checkButton.title = versionStatus?.message ?? "Settings.Title.Check".localized
        }
    }
    
    var hostsType: HostsType! {
        return optionsButton.selectedItem?.title.hostsType
    }
    
    var isChecking: Bool! {
        didSet {
            if isChecking {
                checkButton.isHidden = true
                checkProgress.startAnimation(.none)
            } else {
                checkButton.isHidden = false
                checkProgress.stopAnimation(.none)
            }
        }
    }
    
    override func awakeFromNib() {
        nameLabel.stringValue = AppName
        versionLabel.stringValue =  "v\(AppVersion)"
        
        checkButton.title = "Settings.Title.Check".localized
        checkProgress.isDisplayedWhenStopped = false
        isChecking = false
        
        optionsLabel.stringValue = "Settings.Title.Hosts".localized
        optionsButton.addItems(withTitles: HostsType.names)
        optionsButton.selectItem(withTitle: HostsType.current.name)
        optionsButton.menu?.delegate = self
        
        lookButton.title = "Settings.Title.Look".localized
        
    }
    
    @IBAction func checkAction(_ sender: Any) {
        
        if let status = versionStatus {
            switch status {
            case .available:
                AppReleasesURL.open()
            default:
                break
            }
        } else {
            isChecking = true
            Network.checkVersion { status in
                DispatchQueue.mainAsync {
                    self.isChecking = false
                    self.versionStatus = status
                }
            }
        }

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

