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
    let  kHostsUrl = "https://coding.net/u/scaffrey/p/hosts/git/raw/master/hosts"
    
    var content : String!
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
        self.updateHostsByNetwork(flag:false)
    }

    @IBAction func autoClicked(_ sender: AnyObject) {
        self.updateHostsByNetwork(flag:true)
    }

    func updateHostsByNetwork(flag:Bool)->()
    {
        DJProgressHUD.showStatus("", from: self.view)
        DispatchQueue.global().async {
            do
            {
                if flag
                {
                    self.content = try String(contentsOf: URL(string: self.kHostsUrl)!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                }
                else
                {
                    self.content = try String(contentsOfFile: self.hostsPathText.stringValue, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                }
            }
            catch
            {
                if flag
                {
                    self.alert.messageText = self.kDownloadFail
                }
                else
                {
                    self.alert.messageText = self.kUpdateFail
                }
            }
            
            if self.content != nil
            {
                if self.content!.characters.count > 85 &&
                    self.content!.contains("localhost") &&
                    self.content!.contains("broadcasthost")
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
                self.alert.runModal()
            })
        }
        
    }
    
    func updateByShellScript()
    {
        
        let script = String(format: "do shell script \"echo '%@' >~/../../private/etc/hosts\" with administrator privileges", content)
       
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
    
    @IBAction func lookClicked(_ sender: AnyObject) {
        NSWorkspace.shared().open(URL(string:kHostsUrl)!)
    }

    @IBAction func githubClicked(_ sender: AnyObject) {
        NSWorkspace.shared().open(URL(string:"https://github.com/ZzzM")!)
    }
}

