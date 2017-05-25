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
                if !self.isNetworkModify {
                    self.hintString = NSLocalizedString("UpdateFail", comment: "")
                }
                else{
                    self.hintString = NSLocalizedString("DownloadFail", comment: "")
                }
            }
            
            if self.hostsContent != nil
            {
                if self.hostsContent!.characters.count > 85 &&
                    self.hostsContent!.contains("localhost") &&
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
                if error != nil {
                    hintString = NSLocalizedString("UpdateFail", comment: "")
                }
                else
                {
                    hintString = NSLocalizedString("UpdateSucceed", comment: "")
                }
            }
        }
    }
    
    fileprivate func checkHostsContent() -> (Bool) {
        
        if !isNetworkModify {
            return true
        }
        
        do {
            
            let originalIPStr = try String.init(contentsOfFile: "/private/etc/hosts")
            
            if !originalIPStr.contains("# Modified hosts start") ||
                !originalIPStr.contains("# Modified hosts end") ||
                !originalIPStr.contains("# Modified Hosts Start") ||
                !originalIPStr.contains("# Modified Hosts End"){
                return true
            }
            
            var startFlag,endFlag:String
            if originalIPStr.contains("# Modified hosts start"){
                startFlag = "# Modified hosts start"
                endFlag = "# Modified hosts end"
            }else{
                startFlag = "# Modified Hosts Start"
                endFlag = "# Modified Hosts End"
            }
            
            var startIndex = originalIPStr.range(of: startFlag) as Range!
            var endIndex = originalIPStr.range(of:endFlag) as Range!

            var ipStr_Base1 = originalIPStr[originalIPStr.startIndex..<startIndex!.lowerBound].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let ipStr_Base2 = originalIPStr[endIndex!.upperBound..<originalIPStr.endIndex].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            
            var timeStarIndex = hostsContent.range(of: "# Last updated:") as Range!
            var timeEndIndex = hostsContent.index(timeStarIndex!.upperBound, offsetBy: 11)
            let upTimeStr = hostsContent[timeStarIndex!.lowerBound..<timeEndIndex]
            
            
            if ipStr_Base1.contains("# Last updated:") {
                
                timeStarIndex = ipStr_Base1.range(of: "# Last updated:") as Range!
                timeEndIndex = ipStr_Base1.index(timeStarIndex!.upperBound, offsetBy: 11)
                ipStr_Base1.replaceSubrange(timeStarIndex!.lowerBound..<timeEndIndex, with: upTimeStr)
                
            }else{
                ipStr_Base1 = upTimeStr + "\n" + "\n"  + ipStr_Base1
            }
            
            if hostsContent.contains("# Modified hosts start"){
                startFlag = "# Modified hosts start"
                endFlag = "# Modified hosts end"
            }else{
                startFlag = "# Modified Hosts Start"
                endFlag = "# Modified Hosts End"
            }
            
            startIndex = hostsContent.range(of: startFlag) as Range!
            endIndex = hostsContent.range(of:endFlag) as Range!
            
            hostsContent =
                (ipStr_Base1 + "\n" + "\n" +
                    ipStr_Base2  + "\n" + "\n" +
                    hostsContent[startIndex!.lowerBound..<endIndex!.upperBound]).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
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
