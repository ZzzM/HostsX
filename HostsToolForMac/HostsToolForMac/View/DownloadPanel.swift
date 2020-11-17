//
//  DownloadPanel.swift
//  HostsToolForMac
//
//  Created by zm on 2020/11/17.
//  Copyright © 2020 ZzzM. All rights reserved.
//

import Cocoa

class DownloadPanel: NSPanel {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var task: URLSessionTask!
    
    override func awakeFromNib() {
        
        progressIndicator.startAnimation(.none)
        task = Network.request(url: HostsType.current.url) { [self] in
            Helper.deliverNotification($0.hosts
                                        .compared
                                        .executed
                                        .message)
            
            close(.none)
        } failure: { [self] in
            
            if $0.code == -999 {
                Helper.deliverNotification($0.localizedDescription)
            } else {
                close(.none)
            }
            
        }
        
    }
    
    @IBAction func close(_ sender: Any?) {
        
        DispatchQueue.mainAsync { [self] in
            progressIndicator.stopAnimation(.none)
            close()
        }
        
        task.cancel()
        
    }
    
    
}

extension DownloadPanel: NSWindowDelegate {
    override func close() {
        super.close()
        NSApp.abortModal()
    }
}
