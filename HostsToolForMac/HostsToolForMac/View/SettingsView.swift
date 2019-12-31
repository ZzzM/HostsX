//
//  SettingsView.swift
//  HostsToolForMac
//
//  Created by zm on 2019/12/31.
//  Copyright © 2019 ZzzM. All rights reserved.
//

import Cocoa

let SettingsViewSize = NSSize(width: 400, height: 150)

class SettingsView: NSView {

    @IBOutlet weak var appNameLabel: NSTextField!
    @IBOutlet weak var vTitleLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var checkButton: NSButton!
    @IBOutlet weak var sTitleLabel: NSTextField!
    @IBOutlet weak var comboBox: NSComboBox!
    @IBOutlet weak var lookButton: NSButton!
    
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    var hostsType: HostsType! {
        return comboBox.stringValue.hostsType
    }
    var versionStatus: VersionStatus? {
        didSet {
            checkButton.title = versionStatus?.message ?? "Settings.Title.Check".localized
        }
    }
    
    var isChecking: Bool! {
        didSet {
            if isChecking {
                checkButton.isHidden = true
                indicator.startAnimation(.none)
            } else {
                checkButton.isHidden = false
                indicator.stopAnimation(.none)
            }
        }
    }
    
    override func awakeFromNib() {
        
        appNameLabel.stringValue = AppName
        vTitleLabel.stringValue =  "Settings.Title.Version".localized
        sTitleLabel.stringValue = "Settings.Title.Hosts".localized
        
        checkButton.title = "Settings.Title.Check".localized
        lookButton.title = "Settings.Title.Look".localized
        
        versionLabel.stringValue = "v\(AppVersion)"
        comboBox.stringValue = HostsType.current.name
    
        indicator.isDisplayedWhenStopped = false
        isChecking = false
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
    
}

extension SettingsView: NSComboBoxDataSource {
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return HostsType.allCases.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return HostsType.allCases[index].name
    }
}

extension SettingsView {
    static func show() {
        let alert = NSAlert()
        alert.window.titlebarAppearsTransparent = true
        alert.icon = NSImage()
        alert.window.setContentSize(SettingsViewSize)
        alert.messageText = ""
        
        alert.addButton(withTitle: "Alert.Title.Comfirm".localized)
        alert.addButton(withTitle: "Alert.Title.Cancel".localized)
        let settingsView = SettingsView.loadFromNib()
        settingsView.frame = alert.window.contentView?.bounds ?? .zero
        alert.window.contentView?.addSubview(settingsView)
        
        switch alert.runModal() {
        case .alertFirstButtonReturn:
            HostsType.current = settingsView.hostsType
        default: break
        }

    }
}
