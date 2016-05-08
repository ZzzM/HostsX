//
//  DragView.swift
//  HostsTool
//
//  Created by Misaka on 16/4/28.
//  Copyright © 2016年 ZhangMeng. All rights reserved.
//

import Cocoa

typealias closure=(String)->Void

class DragView: NSView{

    var filePath: String?
    var filePathClosure:closure?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerForDraggedTypes([NSFilenamesPboardType])
        self.wantsLayer = true
        self.configBackgroundColor(0.1)
        
        let tap = NSClickGestureRecognizer.init(target: self, action: #selector(DragView.tapped))
        
        self.addGestureRecognizer(tap)
    }

    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        
        if ((sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray) != nil) {
                return NSDragOperation.Copy
        }
        return NSDragOperation.None
    }
    
  
    override func draggingExited(sender: NSDraggingInfo?) {
        self.configBackgroundColor(0.1)
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        
        if let pasteboard = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            
            if let pathString = pasteboard.firstObject as? String {
                
                if (filePathClosure != nil) {
                    filePathClosure!(pathString)
                }
                //self.filePath?:self.filePath(pathString)
                //Swift.print(pathString)
                self.configBackgroundColor(0.3)
                return true
            }
        }
        return false
    }
    
    func configBackgroundColor(alpha: CGFloat) {
        self.layer?.backgroundColor = NSColor.init(deviceRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: alpha).CGColor
    }
    
    func tapped(){
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                
                if (self.filePathClosure != nil) {
                    self.filePathClosure!(openPanel.URL!.path!)
                }
                
            }
        }
    }
}
