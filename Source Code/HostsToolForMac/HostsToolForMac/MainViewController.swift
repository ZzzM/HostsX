//
//  MainViewController.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 06/03/2017.
//  Copyright © 2017 ZzzM. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    fileprivate let popover = NSPopover()
    fileprivate var alert = Utils.customAlert()
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPopover()
        // Do view setup here.
    }
    
    fileprivate func initPopover() {
        popover.contentViewController = MoreViewController(nibName: "MoreViewController", bundle: nil)
    }
    
    @IBAction func customUpdateButtonClicked(_ sender: Any) {
        if popover.isShown {popover.close()}
        UpdateHosts.customModifyHosts { (hintString) in
            DispatchQueue.main.async(execute: {
                self.alert.informativeText = hintString
                self.alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            })
        }
    }
  
    @IBAction func networkUpdateButtonClicked(_ sender: Any) {
        if popover.isShown {popover.close()}
        progressIndicator.startAnimation(nil)
        UpdateHosts.NetworkModifyHosts { (hintString) in
            DispatchQueue.main.async(execute: {
                self.progressIndicator.stopAnimation(nil)
                self.alert.informativeText = hintString
                self.alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            })
        }
    }
    
    @IBAction func moreButtonClicked(_ sender: NSButton) {
        if popover.isShown {
            popover.close()
        }else{
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxX)
        }
    }
    
    @IBAction func exitButtonClicked(_ sender: Any) {
        
        NSApplication.shared().terminate(nil)
    }
 
    
}
