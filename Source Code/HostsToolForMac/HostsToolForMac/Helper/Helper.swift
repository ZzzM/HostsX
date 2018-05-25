//
//  Helper.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/21.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import SwifterSwift


let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let AppName = "HostsToolforMac"

let ApiReleasesURL = URL(string: "https://api.github.com/repos/ZzzM/HostsToolforMac/releases/latest")!
let ReleasesURL = URL(string: "https://github.com/ZzzM/HostsToolforMac/releases")!

let DefaultUpdateURL = URL(string:"https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts")!
let MirrorUpdateURL = URL(string:"https://coding.net/u/scaffrey/p/hosts/git/raw/master/hosts-files/hosts")!



let StartMark = "# My Hosts Start"
let EndMark = "# My Hosts End"
let ShowMark = "🤓"

let TargetDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

let TargetPath = TargetDirectory + "/hosts"

var openPanel: Observable<String> {
    let value = NSOpenPanel()
    value.allowsMultipleSelection = false
    value.canChooseDirectories = false
    value.canCreateDirectories = false
    value.canChooseFiles = true
    
    guard value.runModal().rawValue == NSFileHandlingPanelOKButton else {
        return Observable.just("")
    }
    guard let path = value.url?.path  else {
        return Observable.just("")
    }
    do {
        return try String(contentsOfFile: path).checked
    } catch{
        return Observable.error(error)
    }

}


class Helper: NSObject {
    

    static func error(_ message: String) -> NSError {
        return NSError(domain: "HelperError", code: -1, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    static func showMessage(_ message:String) {
        let n = NSUserNotification()
        n.title = AppName + " v" + AppVersion
        n.informativeText = message
        n.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(n)
    }
    
    
}

extension Observable where Element == String {

    func compare() -> Observable<Element> {
        
    
        return self.map({ network in

            let content = StartMark
                + "\n"*2 + ShowMark
                + "\n"*2 + EndMark
                + "\n"*2 + network

            
            guard let local = try? String.init(contentsOfFile: "/private/etc/hosts") else{
                return content
            }
            
            guard
                let startIndex = local.range(of: StartMark)?.upperBound,
                let endIndex = local.range(of: EndMark)?.lowerBound else{
                
                return content
                
            }
            
            return content.replacingOccurrences(of: ShowMark, with: local[startIndex..<endIndex].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
            
        })

        
    }
    
    
    func execute() -> Observable<Element> {
        
        return self.map{ hosts in
            
            defer{try? FileManager.default.removeItem(atPath: TargetPath)}
            
            guard hosts.create else{
                throw Helper.error("Error.Hosts.Creation".localized())
            }
            
            guard let scriptObject = NSAppleScript(source: TargetPath.script) else{
                throw Helper.error("Error.Script.Compile".localized())
            }
            
            var errorDic : NSDictionary? = nil
            scriptObject.executeAndReturnError(&errorDic)
            
            
            guard let error = errorDic,let message = error["NSAppleScriptErrorMessage"] as? String else {
                return "Hint.Script.Succeed".localized()
            }
            
            throw Helper.error("Error.Script.Execution".localized() + message)
        }
    }

  
}


extension URL{
    var hosts: Observable<String> {

        do {
            return try String(contentsOf: self).checked
        } catch{
        
            guard let underlyingError = error.userInfo["NSUnderlyingError"] as? Error else {
                return Observable.error(error)
            }
            return Observable.error(underlyingError)
            
        }
    }
}

extension String{
    var create: Bool {
        
        return FileManager.default.createFile(atPath:TargetPath, contents: self.data(using: .utf8), attributes: nil)
    }
    
    
    var script: String {
        return "do shell script \"cp -f \(self) ~/../../private/etc/hosts\" with administrator privileges"
    }
    
    var intVersion: Int {
        return self.replacingOccurrences(of: ".", with: "").int!
    }
    var needUpdate: Bool{
        return AppVersion.intVersion >= self.intVersion
    }
    
    var checked: Observable<String>  {
        
        guard
            self.contains("localhost") &&
            self.contains("127.0.0.1") &&
            self.contains("::1") else{
            return Observable.error(Helper.error("Error.Hosts.Invalid".localized()))
        }
        return Observable.just(self)
    }
 
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var userInfo: [String : Any] { return (self as NSError).userInfo }
}


extension AppDelegate:NSUserNotificationCenterDelegate{
 

    func setStatusBarItem(_ barItem: NSStatusItem) {
        let itemIcon = #imageLiteral(resourceName: "AppIcon_s")
        itemIcon.isTemplate = true
        barItem.image = itemIcon
        barItem.menu = menu
    }
    
    
    func setUserNotification(){
        NSUserNotificationCenter.default.delegate = self
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        
        guard notification.informativeText == "Hint.Version.Availble".localized() else{return}
        NSWorkspace.shared.open(ReleasesURL)
        
    }
    
}

