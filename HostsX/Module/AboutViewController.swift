//
//  AboutViewController.swift
//  HostsX
//
//  Created by zm on 2021/12/22.
//

import Cocoa

class AboutViewController: NSViewController {

    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var copyrightLabel: NSTextField!

    @IBOutlet weak var checkButton: NSButton!

    private var name = Bundle.main.bundleName ?? "HostsX"

    private var version: String {
        guard let version = Bundle.main.version, let hash = Bundle.main.commitHash else {
            return ""
        }
        return "\(L10n.About.version) \(version) (\(hash))"
    }
    private var copyright = Bundle.main.humanReadableCopyright ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.image = NSApp.applicationIconImage
        nameLabel.stringValue = name
        versionLabel.stringValue = version
        copyrightLabel.stringValue = copyright
        checkButton.title = L10n.About.check
        
    }

    @IBAction func onGitHub(_ sender: Any) {
        NSWorkspace.open(HXURL.github)
    }
}
