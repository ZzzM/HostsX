//
//  SettingViewController.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 06/03/2017.
//  Copyright © 2017 ZzzM. All rights reserved.
//

import Cocoa


class SettingViewController: NSViewController {

    @IBOutlet weak var hostsTextField: CustomTextField!

    
    fileprivate let kDefaultButtonTag = 1
    fileprivate let kDefaultCheckButtonTag = 10
    fileprivate let kMirrorCheckButtonTag = 20
    fileprivate let kCustomCheckButtonTag = 30
    fileprivate let kComfirmButtonTag = 40

    fileprivate var selectedCheckButton : NSButton!
    fileprivate var isEditable: Bool { return  kCustomCheckButtonTag == selectedCheckButton.tag }
    
    fileprivate var alert = Utils.customAlert()
    
    fileprivate let currentLink = Utils.fetchCurrentHostsLink()
    fileprivate let updateLink = Utils.fetchCustomUpdateLink()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCheckBox()
        // Do view setup here.
    }
    
    fileprivate func initCheckBox() {

        if  currentLink == Utils.kDefaultHostsLink {
            selectedCheckButton = self.view.viewWithTag(kDefaultCheckButtonTag) as! NSButton
        }else if currentLink == Utils.kMirrorHostsLink {
            selectedCheckButton = self.view.viewWithTag(kMirrorCheckButtonTag) as! NSButton
        }else{
            selectedCheckButton = self.view.viewWithTag(kCustomCheckButtonTag) as! NSButton
        }

        selectedCheckButton.state = NSOnState
        hostsTextField.isEditable = isEditable
        hostsTextField.stringValue = updateLink
    }
    
    fileprivate func setAndSaveCustomUpdateLink(){
        if hostsTextField.stringValue == "" {
            
            DispatchQueue.main.async(execute: {
                self.alert.informativeText = self.hostsTextField.placeholderString!
                self.alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            })
            
        }else{
            
            if hostsTextField.stringValue .contains("http://") || hostsTextField.stringValue .contains("https://"){
                
                Utils.saveCurrentHostsLink(link: hostsTextField.stringValue)
                Utils.saveCustomUpdateLink(link: hostsTextField.stringValue)
                self.dismiss(nil)
                
            }else{
                
                self.alert.informativeText = NSLocalizedString("LinkError", comment: "")
                self.alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            }
            
        }
    }
    
    @IBAction func detailButtonClicked(_ sender: NSButton) {
        if kDefaultButtonTag == sender.tag {
            NSWorkspace.shared().open(URL(string:Utils.kDefaultHostsLink)!)
        }else{
            NSWorkspace.shared().open(URL(string:Utils.kMirrorHostsLink)!)
        }
    }

    @IBAction func submitButtonClicked(_ sender: NSButton) {
        if kComfirmButtonTag == sender.tag {
            switch selectedCheckButton.tag {
            case kDefaultCheckButtonTag:
                Utils.saveCurrentHostsLink(link: Utils.kDefaultHostsLink);break
            case kMirrorCheckButtonTag:
                Utils.saveCurrentHostsLink(link: Utils.kMirrorHostsLink);break
            case kCustomCheckButtonTag:
                return self.setAndSaveCustomUpdateLink()
            default:break
            }
            self.dismiss(nil)
        }else{self.dismiss(nil)}
    }
    
    @IBAction func checkBoxButtonClicked(_ sender: NSButton) {
        
        selectedCheckButton.state = NSOffState
        selectedCheckButton = sender
        selectedCheckButton.state = NSOnState
        
        hostsTextField.isEditable = isEditable

    }

    
}


