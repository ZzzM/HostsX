//
//  Utils.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 06/03/2017.
//  Copyright © 2017 ZzzM. All rights reserved.
//

import Cocoa

class Utils: NSObject {
    
    static let  CustomUpdateLink = "CustomUpdateLink"
    static let  CurrentHostsLink = "CurrentHostsLink"
    
    static let kDefaultHostsLink = "https://raw.githubusercontent.com/racaljk/hosts/master/hosts"
    static let kMirrorHostsLink = "https://coding.net/u/scaffrey/p/hosts/git/raw/master/hosts"
    static let kProjectLink = "https://github.com/ZzzM/HostsToolforMac"
    static let kProjectName = "HostsToolforMac"
    static let kProjectReleasesLink = "https://api.github.com/repos/ZzzM/HostsToolforMac/releases"
    static let  StatusIcon = NSImage(named: "smallIcon")
    static let  AlertIcon = NSImage(named: "bigIcon")
    
    
    
    class func checkVersoin(newestVersion: String)->Bool{
        
        let currentVersionValue = Int((Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String).replacingOccurrences(of: "v", with: "").replacingOccurrences(of: ".", with: ""))!
        let newestVersionValue = Int(newestVersion.replacingOccurrences(of: "v", with: "").replacingOccurrences(of: ".", with: ""))!
        return currentVersionValue<newestVersionValue
    
    }
    
    class func customAlert() -> NSAlert{
        let alert = NSAlert()
        alert.messageText = ""
        alert.icon = AlertIcon
        return alert
    }
    
 
    class func saveCustomUpdateLink(link:String) {
        UserDefaults.standard.set(link, forKey: Utils.CustomUpdateLink)
    }
    
    class func fetchCustomUpdateLink()->String {
        guard  UserDefaults.standard.string(forKey: Utils.CustomUpdateLink) != nil else {
            return ""
        }
        return UserDefaults.standard.string(forKey: Utils.CustomUpdateLink)!
    }
    
    class func saveCurrentHostsLink(link:String) {
        UserDefaults.standard.set(link, forKey: Utils.CurrentHostsLink)
    }
    
    class func fetchCurrentHostsLink()->String {
        
        guard  UserDefaults.standard.string(forKey: Utils.CurrentHostsLink) != nil else {
            return ""
        }
        return UserDefaults.standard.string(forKey: Utils.CurrentHostsLink)!
    }
}
