//
//  UpdateHosts.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 07/03/2017.
//  Copyright © 2017 ZzzM. All rights reserved.
//

import Cocoa

typealias finishedBlock = (String)->Void

class UpdateHosts: NSObject {
    
    static fileprivate let sharedInstance = UpdateHosts()
    
    fileprivate var hintString : String!
    fileprivate var hostsContent : String!
    fileprivate var hostsFilePath : String!
    fileprivate var isNetworkModify : Bool!
    fileprivate var block : finishedBlock!
    
    class func customModifyHosts(finishedBlock:@escaping finishedBlock) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                sharedInstance.hostsFilePath = openPanel.url!.path
                sharedInstance.isNetworkModify = false
                sharedInstance.block = finishedBlock
                sharedInstance.fetchHostsContent()
            }
        }
    }
    
    class func NetworkModifyHosts(finishedBlock:@escaping finishedBlock) {
        sharedInstance.isNetworkModify = true
        sharedInstance.block = finishedBlock
        sharedInstance.fetchHostsContent()
    }
    
    
    fileprivate func fetchHostsContent(){
        DispatchQueue.global().async {
            do
            {
                self.hostsContent = try !self.isNetworkModify ?
                    String(contentsOfFile: self.hostsFilePath, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)):
                    String(contentsOf: URL(string: Utils.fetchCurrentHostsLink())!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            }
            catch
            {
                self.hintString = !self.isNetworkModify ?
                    NSLocalizedString("UpdateFail", comment: ""):
                    NSLocalizedString("DownloadFail", comment: "")
            }
            
            if self.hostsContent != nil
            {
                if self.hostsContent!.contains("localhost") &&
                    self.hostsContent!.contains("127.0.0.1") &&
                    self.hostsContent!.contains("::1")
                {
                     self.executeScript()
                }
                else
                {
                    self.hintString = NSLocalizedString("HostsError", comment: "")
                }
            }
            else
            {
                self.hintString = NSLocalizedString("HostsBlank", comment: "")
            }
            
            self.hostsContent = nil
            self.block(self.hintString)
            
        }
    }
    
    
   fileprivate func executeScript()
    {
        if self.checkHostsContent() {
            
            let script = String(format: "do shell script \"echo '%@' >~/../../private/etc/hosts\" with administrator privileges",hostsContent)
            
            if let scriptObject = NSAppleScript(source: script)
            {
                var error: NSDictionary?
                scriptObject.executeAndReturnError(&error)
                
                hintString = error != nil ?
                    NSLocalizedString("UpdateFail", comment: ""):
                    NSLocalizedString("UpdateSucceed", comment: "")
            }
        }
    }
    
    fileprivate func checkHostsContent() -> (Bool) {
        
        if !isNetworkModify {
            return true
        }
        
        do {
            
            let originalIPStr = try String.init(contentsOfFile: "/private/etc/hosts")
            
            //v2.2.3
            var oldYourHosts = String()
            if originalIPStr.contains(Utils.YourMark){
                let yourMarkIndex = originalIPStr.range(of:Utils.YourMark) as Range!
                oldYourHosts = originalIPStr[yourMarkIndex!.upperBound..<originalIPStr.endIndex].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            }
            
            // new version
            var newYourHosts = String()

            if originalIPStr.contains(Utils.StartMark) &&
                originalIPStr.contains(Utils.EndMark){
                let startMarkIndex = originalIPStr.range(of:Utils.StartMark) as Range!
                let endMarkIndex = originalIPStr.range(of:Utils.EndMark) as Range!
                
                newYourHosts = originalIPStr[startMarkIndex!.upperBound..<endMarkIndex!.lowerBound].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            }
            
            hostsContent =
                Utils.StartMark + "\n\n" +
                oldYourHosts + (oldYourHosts.isEmpty ?"":"\n") +
                newYourHosts  + "\n\n" +
                Utils.EndMark + "\n\n" + hostsContent
            
            return true
            
        } catch {
            
            switch error.code {
            case 260:
                hintString = NSLocalizedString("HostsNotExsit", comment: "")
            default: break
            }
            return false
            
        }
    }
}
