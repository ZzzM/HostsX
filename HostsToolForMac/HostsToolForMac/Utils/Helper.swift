//
//  Helper.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/21.
//  Copyright © 2018年 ZzzM. All rights reserved.
//
import Cocoa
import UserNotifications
struct Helper {
    
    static func creatFile(atPath: String, contents: String) -> Bool {
        
        return FileManager.default.createFile(
            atPath: atPath,
            contents: contents.data(using: .utf8), attributes: .none)
    }
    
    static func removeFile(atPath: String) {
        try? FileManager.default.removeItem(atPath: atPath)
    }
    
    
    static func openPanel() -> URL? {
        let _openPanel = NSOpenPanel()
        _openPanel.allowsMultipleSelection = false
        _openPanel.canChooseDirectories = false
        _openPanel.canCreateDirectories = false
        _openPanel.canChooseFiles = true

        guard _openPanel.runModal() == .OK else {
            return .none
        }

        return _openPanel.url
    }
    
    static func deliverNotification(_ message: String?) {
        
        
        guard message != .none else {
            return
        }
        if #available(OSX 10.14, *) {
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: [.alert, .sound],
//                completionHandler: <#T##(Bool, Error?) -> Void#>)
 
            let content = UNMutableNotificationContent()
            content.title = "\(AppName) v\(AppVersion)"
            content.body = message!
            content.sound = .default
            let request = UNNotificationRequest(identifier: AppName, content: content, trigger: .none)
            UNUserNotificationCenter.current().add(request)
        } else {
            let notification = NSUserNotification()
            notification.title = "\(AppName) v\(AppVersion)"
            notification.informativeText = message!
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(notification)
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
            return .none
        }
    }

}

extension ExecutionResult {
    var compared: ExecutionResult {
        
        switch self {
        case .success:
            break
        default:
            return self
        }
        
        let content = StartMark +
            "\n\n" + ShowMark +
            "\n\n" + EndMark +
            "\n\n" + message!
        
        guard let local = try? String(contentsOfFile: "/private/etc/hosts") else{
            return .success(content)
        }
        
        guard
            let startIndex = local.range(of: StartMark)?.upperBound,
            let endIndex = local.range(of: EndMark)?.lowerBound else{
                
                return .success(content)
        }
        return .success(
            content
                .replacingOccurrences(of: ShowMark, with: local[startIndex..<endIndex]
                    .trimmingCharacters(in: .whitespacesAndNewlines)))
    }
    
    var executed: ExecutionResult {
        
        defer {
            Helper.removeFile(atPath: TargetPath)
        }
        
        switch self {
        case .success:
            break
        default:
            return self
        }

        guard Helper.creatFile(atPath: TargetPath, contents: message!) else {
            return ExecutionResult.error("Error.Hosts.Creation".localized)
        }
        
        let source =
        "do shell script" +
        #" "cp -f \#(TargetPath) ~/../../private/etc/hosts" "# +
        "with administrator privileges"
        
        guard let scriptObject = NSAppleScript(source: source) else{
            return ExecutionResult
                .error("Error.Script.Compile".localized)
        }
        
        var errorDic : NSDictionary?
        scriptObject.executeAndReturnError(&errorDic)
        
        guard let error = errorDic,
            let message = error["NSAppleScriptErrorMessage"] as? String else {
                return ExecutionResult
                    .error("Hint.Script.Succeed".localized)
        }
        
        return ExecutionResult
            .error("Error.Script.Execution".localized + message)
    }
}
