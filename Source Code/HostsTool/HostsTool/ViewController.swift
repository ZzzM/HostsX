//
//  ViewController.swift
//  HostsTool
//
//  Created by Misaka on 16/2/16.
//  Copyright © 2016年 ZhangMeng. All rights reserved.
//

import Cocoa



class ViewController: NSViewController {

    let kUpdateFail = "更新失败"
    let kUpdateSuccess = "更新成功"
    let kAddHosts = "请检查导入的内容"
    let kNoHosts = "hosts为空"
    let kDownloadFail = "hosts下载失败,请检查网络连接"
    let kPlaceholder = "拖拽或者点击来添加hosts"
    let kHostsUrl = "https://coding.net/u/scaffrey/p/hosts/git/raw/master/hosts"
    
    
    var content : String!
    var isManual : Bool!
    let alert:NSAlert = NSAlert()
    
    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var hostsPathText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dragView.filePathClosure = {
            (filePathString)->Void in
            self.hostsPathText.stringValue = filePathString;
        }
    }

    @IBAction func manualClicked(_ sender: AnyObject) {
        isManual = true
        self.updateHostsByNetwork()
    }

    @IBAction func autoClicked(_ sender: AnyObject) {
        isManual = false
        self.updateHostsByNetwork()
    }

    func updateHostsByNetwork()->()
    {
        DJProgressHUD.showStatus("", from: self.view)
        DispatchQueue.global().async {
            do
            {
                self.content = try !self.isManual ?
                    String(contentsOf: URL(string: self.kHostsUrl)!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)):
                    String(contentsOfFile: self.hostsPathText.stringValue, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            }
            catch
            {
                self.alert.messageText = !self.isManual ?
                    self.kDownloadFail:
                    self.kUpdateFail
            }
            
            
            if self.content != nil
            {
                if self.content!.characters.count > 85 &&
                    self.content!.contains("localhost") &&
                    self.content!.contains("127.0.0.1") &&
                    self.content!.contains("::1")
                {
                    self.updateByShellScript()
                }
                else
                {
                    self.alert.messageText = self.kAddHosts
                }
            }
            else
            {
                self.alert.messageText = self.kNoHosts
            }
            
            DispatchQueue.main.async(execute: {
                if self.alert.messageText != self.kUpdateSuccess
                {
                    self.dragView.configBackgroundColor(0.1)
                    self.hostsPathText.stringValue = self.kPlaceholder
                }
                DJProgressHUD.dismiss()
                self.content = nil
                self.alert.runModal()
            })
        }
        
    }
    
    func updateByShellScript()
    {
        if self.fetchNewHosts() {
            let script = String(format: "do shell script \"echo '%@' >~/../../private/etc/hosts\" with administrator privileges",content)
            
            if let scriptObject = NSAppleScript(source: script)
            {
                var error: NSDictionary?
                scriptObject.executeAndReturnError(&error)
                if error != nil {
                    alert.messageText = self.kUpdateFail
                }
                else
                {
                    alert.messageText = self.kUpdateSuccess
                }
            }
        }
    }
    
    @IBAction func lookClicked(_ sender: AnyObject) {
        NSWorkspace.shared().open(URL(string:kHostsUrl)!)
    }

    @IBAction func githubClicked(_ sender: AnyObject) {
        NSWorkspace.shared().open(URL(string:"https://github.com/ZzzM")!)
    }
    
     func fetchNewHosts() -> (Bool) {
        
        if self.isManual! {
            return true
        }
        
        do {
            
            let OriginalIPStr = try String.init(contentsOfFile: "/private/etc/hosts")
            var startIndex = OriginalIPStr.range(of: "# Modified hosts start") as Range!
            var endIndex = OriginalIPStr.range(of: "# Modified hosts end") as Range!
            
            var ipStr_Base1 = OriginalIPStr[OriginalIPStr.startIndex..<startIndex!.lowerBound].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let ipStr_Base2 = OriginalIPStr[endIndex!.upperBound..<OriginalIPStr.endIndex].trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            
            var timeStarIndex = content.range(of: "# Last updated:") as Range!
            var timeEndIndex = content.index(timeStarIndex!.upperBound, offsetBy: 11)
            let upTimeStr = content[timeStarIndex!.lowerBound..<timeEndIndex]
            
            
            if ipStr_Base1.contains("# Last updated:") {
                
                timeStarIndex = ipStr_Base1.range(of: "# Last updated:") as Range!
                timeEndIndex = ipStr_Base1.index(timeStarIndex!.upperBound, offsetBy: 11)
                ipStr_Base1.replaceSubrange(timeStarIndex!.lowerBound..<timeEndIndex, with: upTimeStr)
                
            }else{
                ipStr_Base1 = upTimeStr + "\n" + "\n"  + ipStr_Base1
            }
            
            
            
            startIndex = content.range(of: "# Modified hosts start") as Range!
            endIndex = content.range(of: "# Modified hosts end") as Range!
            

            content =
                (ipStr_Base1 + "\n" + "\n" +
                ipStr_Base2  + "\n" + "\n" +
                content[startIndex!.lowerBound..<endIndex!.upperBound]).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            return true
            
        } catch {
            print(error)
            return false
        }
    }
    
    
}


