//
//  HostsURLCell.swift
//  HostsX
//
//  Created by zm on 2021/12/2.
//

import Cocoa

class HostsURLCell: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!

    @IBOutlet weak var starLabel: NSTextField!

    @IBOutlet weak var urlLabel: NSTextField!


    override func awakeFromNib() {
        starLabel.stringValue = Localization.Hosts.origin
    }

    var hosts: Hosts! {
        didSet {
            titleLabel.stringValue = hosts.alias
            starLabel.isHidden = !hosts.isOrigin
            urlLabel.stringValue = hosts.url
        }
    }

    
}
