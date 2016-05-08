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
    let kAddHosts = "请导入正确的hosts"
    let kNoHosts = "hosts为空"
    let kDownloadFail = "hosts下载失败,请检查网络连接"
    let kNoPermission = "请依次开启\"/private/etc/hosts\"目录下，etc文件夹和hosts的\"读与写\"权限"
    let kPlaceholder = "拖拽或者点击来添加hosts"
    let  kHostsUrl = "https://raw.githubusercontent.com/racaljk/hosts/master/hosts"
    
    var content : NSString!
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

   
    @IBAction func manualClicked(sender: AnyObject) {
        let pathString:NSString =  self.hostsPathText.stringValue
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
                    self.content = try NSString(contentsOfFile: self.hostsPathText.stringValue, encoding: NSUTF8StringEncoding)
                    self.updateHosts()
                }
                catch
                {
                    self.alert.messageText = self.kUpdateFail
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                DJProgressHUD.dismiss()
                if self.alert.messageText != self.kUpdateSuccess
                {
                    self.dragView.configBackgroundColor(0.1)
                    self.hostsPathText.stringValue = self.kPlaceholder
                }
                self.alert.runModal()
            })
        })

    }

    @IBAction func autoClicked(sender: AnyObject) {
        DJProgressHUD.showStatus("", fromView: self.view)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            do
            {
                self.content = try NSString(contentsOfURL: NSURL(string: self.kHostsUrl)!, encoding: NSUTF8StringEncoding)
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
    
    @IBAction func lookClicked(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string:kHostsUrl)!)
    }
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

