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
let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

let ApiReleasesURL = URL(string: "https://api.github.com/repos/ZzzM/HostsToolforMac/releases/latest")!
let ReleasesURL = URL(string: "https://github.com/ZzzM/HostsToolforMac/releases")!

let DefaultUpdateURL = URL(string:"https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts")!
let MirrorUpdateURL = URL(string:"https://coding.net/u/scaffrey/p/hosts/git/raw/master/hosts-files/hosts")!



let StartMark = "# My Hosts Start"
let EndMark = "# My Hosts End"
let ShowMark = "🤓"

let TargetDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

let TargetPath = TargetDirectory + "/hosts"

enum VersionStatus {
    case latest, availble, error(String)
    
    var message: String {
        switch self {
        case .latest:
            return "Hint.Version.Latest".localized()
        case .availble:
            return "Hint.Version.Availble".localized()
        case .error(let msg):
            return msg
        }
    }
}

enum ExecutionResult {
    case success(String), invalid, error(String)
    
    var message: String? {
        switch self {
        case .success(let msg),
             .error(let msg):
            return msg
        default:
            return nil
        }
    }
}

var openPanel: Observable<ExecutionResult> {
    let value = NSOpenPanel()
    value.allowsMultipleSelection = false
    value.canChooseDirectories = false
    value.canCreateDirectories = false
    value.canChooseFiles = true
    
    guard value.runModal().rawValue == NSFileHandlingPanelOKButton else {
        return Observable.just(ExecutionResult.invalid)
    }
    guard let path = value.url?.path  else {
        return Observable.just(ExecutionResult.invalid)
    }
    do {
        return try String(contentsOfFile: path).checked
    } catch {
        return Observable.just(
            ExecutionResult.error(error.localizedDescription))
    }

}

import UserNotifications

func deliverNotification(_ message: String?) {
    guard message != nil else {
        return
    }
    
    if #available(OSX 10.14, *) {
        let content = UNMutableNotificationContent()
        content.title = "\(AppName) v\(AppVersion)"
        content.body = message!
        content.sound = .default
        let request = UNNotificationRequest(identifier: AppName, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    } else {
        let notification = NSUserNotification()
        notification.title = "\(AppName) v\(AppVersion)"
        notification.informativeText = message!
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }

}


extension Observable where Element == ExecutionResult {

    var compare: Observable<Element> {
        
    
        return
            
            map{
                
                switch $0 {
                case .success:
                    break
                default:
                    return $0
                }
                
                let content = StartMark
                    + "\n"*2 + ShowMark
                    + "\n"*2 + EndMark
                    + "\n"*2 + $0.message!
                
                
                guard let local = try? String(contentsOfFile: "/private/etc/hosts") else{
                    return ExecutionResult.success(content)
                }
                
                guard
                    let startIndex = local.range(of: StartMark)?.upperBound,
                    let endIndex = local.range(of: EndMark)?.lowerBound else{
                        
                        return ExecutionResult.success(content)
                }
                return ExecutionResult.success(
                    content
                        .replacingOccurrences(of: ShowMark, with: local[startIndex..<endIndex]
                            .trimmingCharacters(in: .whitespacesAndNewlines)))
        }
        
        
    }
    
    
    var execute: Observable<Element> {
        

        return
            
            map{
                
                defer{ try? FileManager.default.removeItem(atPath: TargetPath) }
                
                switch $0 {
                case .success:
                    break
                default:
                    return $0
                }
                
                guard $0.message!.create else{
                    
                    return ExecutionResult
                        .error("Error.Hosts.Creation".localized())
                }
                
                guard let scriptObject = NSAppleScript(source: TargetPath.script) else{
                    return ExecutionResult
                        .error("Error.Script.Compile".localized())
                }
                
                var errorDic : NSDictionary?
                scriptObject.executeAndReturnError(&errorDic)
                
                
                guard let error = errorDic,let message = error["NSAppleScriptErrorMessage"] as? String else {
                    return ExecutionResult
                        .error("Hint.Script.Succeed".localized())
                }
                
                return ExecutionResult
                    .error("Error.Script.Execution".localized() + message)
        }
    }
    
    
}


extension URL{
    var hosts: Observable<ExecutionResult> {
        
        do {
            return try String(contentsOf: self).checked
        } catch{
            
            guard let underlyingError = error.userInfo["NSUnderlyingError"] as? Error else {
                return Observable.just(ExecutionResult.error(error.localizedDescription))
            }
            return Observable.just(ExecutionResult.error(underlyingError.localizedDescription))
            
        }
    }
}

extension String{
    
    var create: Bool {
        
        return FileManager.default.createFile(atPath:TargetPath, contents: self.data(using: .utf8), attributes: nil)
    }
    
    
    var script: String {
        return #"do shell script "cp -f \#(self) ~/../../private/etc/hosts" with administrator privileges"#
    }
    
    var intVersion: Int {
        return self.replacingOccurrences(of: ".", with: "").int!
    }
    
    var isLatest: Bool{
        return AppVersion.intVersion >= self.intVersion
    }
    
    var checked: Observable<ExecutionResult>  {
        
        guard
            self.contains("localhost") &&
                self.contains("127.0.0.1")
            else{
                return Observable
                    .just(ExecutionResult.error("Error.Hosts.Invalid".localized()))
        }
        return Observable.just(ExecutionResult.success(self))
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

