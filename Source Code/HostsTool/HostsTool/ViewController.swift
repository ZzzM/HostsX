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
    let kAddHosts = "请导入hosts文件"
    let kNoHosts = "hosts文件为空"
    let kDownloadFail = "hosts下载失败,请检查网络连接"
     let kNoPermission = "请依次开启\"/private/etc/hosts\"目录下，etc文件夹和hosts的\"读与写\"权限"
    
    var content : NSString!
    let alert:NSAlert = NSAlert()
    
    @IBOutlet weak var pathLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func selectHostsPathButtonClicked(sender: AnyObject) {
    
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                self.pathLabel.stringValue = openPanel.URL!.path!
            }
        }
      
    }
    
    @IBAction func manualUpdateHosts(sender: AnyObject) {
    
        
        let pathString:NSString =  self.pathLabel.stringValue
       
        let array:NSArray = pathString.componentsSeparatedByString("/")
        
        DJProgressHUD.showStatus("", fromView: self.view)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            if String(array.lastObject!) != "hosts"
            {
                self.alert.messageText = self.kAddHosts
            }
            else
            {
                do
                {
                    self.content = try NSString(contentsOfFile: self.pathLabel.stringValue, encoding: NSUTF8StringEncoding)
                    self.updateHosts()
                }
                catch
                {
                    self.alert.messageText = self.kUpdateFail
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                DJProgressHUD.dismiss()
                self.alert.runModal()
            })
        })
        
        
        
    }

    @IBAction func autoUpdateHosts(sender: AnyObject) {
        
        DJProgressHUD.showStatus("", fromView: self.view)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            do
            {
                self.content = try NSString(contentsOfURL: NSURL(string: "https://raw.githubusercontent.com/racaljk/hosts/master/hosts")!, encoding: NSUTF8StringEncoding)
                self.updateHosts()
            }
            catch
            {
                self.alert.messageText = self.kDownloadFail
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                DJProgressHUD.dismiss()
                self.alert.runModal()
            })
        })
        
    }
    
    func updateHosts()
    {
        let hosts:String = "/private/etc/hosts"
        if content.length > 0
        {
            
            do
            {
                try content .writeToFile(hosts, atomically: true, encoding: NSUTF8StringEncoding)
                
                alert.messageText = self.kUpdateSuccess
            }
            catch let error as NSError
            {
                if error.localizedDescription.containsString("permission")
                {
                    alert.messageText = self.kNoPermission
                }
                else
                {
                    alert.messageText = self.kUpdateFail
                }
                
            }
            
        }
        else
        {
            alert.messageText = self.kNoHosts
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

