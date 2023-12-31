//
//  HostsURLCell.swift
//  HostsX
//
//  Created by zm on 2021/12/2.
//

import Cocoa

class SourceCellView: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!

    @IBOutlet weak var urlLabel: NSTextField!

    @IBOutlet weak var defaultLabel: NSTextField!
    @IBOutlet weak var contentView: NSView!

    @IBOutlet weak var defaultButton: NSButton!


    var showMenu: VoidClosure?
    var setDefault: VoidClosure?
    

    override func updateLayer() {
        contentView.layer?.backgroundColor = NSColor.cellBackground.cgColor
    }

    override func awakeFromNib() {
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 5
    }

    var source: Source! {
        didSet {



            
            titleLabel.stringValue = source.tag
            urlLabel.stringValue = source.url
            defaultLabel.isHidden = !source.isDefault
            defaultButton.isHidden = source.isDefault

        }
    }

    @IBAction func moreAction(_ sender: NSButton) {

        showMenu?()
        let location = NSPoint(x: 0, y: sender.frame.height + 5)
        let menu = sender.menu!
        menu.popUp(positioning: .none, at: location, in: sender)
    }

    @IBAction func defaultAction(_ sender: Any) {
        setDefault?()
    }



}

