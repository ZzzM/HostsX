//
//  MoreViewController.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 06/03/2017.
//  Copyright © 2017 ZzzM. All rights reserved.
//

import Cocoa

class MoreViewController: NSViewController {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    fileprivate var alert = Utils.customAlert()
    fileprivate var goDownloadAlert = Utils.customAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initAlert()
        // Do view setup here.
    }
    
    fileprivate func initAlert(){
        
        goDownloadAlert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
        goDownloadAlert.addButton(withTitle: NSLocalizedString("GoDownload", comment: ""))
  
    }
    
    @IBAction func settingHostsAddressButtonClicked(_ sender: Any) {
        self.presentViewControllerAsSheet(SettingViewController())
    }
    
    @IBAction func checkForUpdateButtonClicked(_ sender: Any) {
        
        progressIndicator.startAnimation(nil)
        Network.requestCheckVersion { (isOldVersion, error) in
            
            
            if error != nil {
                self.alert.informativeText = NSLocalizedString("CheckUpdateFail", comment: "")
            }else{
                
                if isOldVersion {
                    self.goDownloadAlert.informativeText = NSLocalizedString("HaveNewVersion", comment: "")
                }else{
                    self.alert.informativeText = NSLocalizedString("NewestVersion", comment: "")
                }
            }
            
            DispatchQueue.main.async(execute: {
                self.progressIndicator.stopAnimation(nil)
                if self.alert.informativeText == ""{
                    self.goDownloadAlert.beginSheetModal(for: self.view.window!, completionHandler: { (returnCode) in
                        if returnCode == NSAlertSecondButtonReturn{
                            NSWorkspace.shared().open(URL(string:Utils.kProjectLink)!)
                        }
                    })
                }else{
                    self.alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                }

            })
            
        }
    }
    
}
