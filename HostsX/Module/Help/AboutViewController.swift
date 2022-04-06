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

    private var name = Bundle.main.bundleName ?? "HostsX"

    private var version: String {
        guard let short = Bundle.main.shortVersion, let build = Bundle.main.version else {
            return ""
        }
        return "\(Localization.About.version) \(short) (\(build))"
    }
    private var copyright = Bundle.main.humanReadableCopyright ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.image = NSApp.applicationIconImage
        nameLabel.stringValue = name
        versionLabel.stringValue = version
        copyrightLabel.stringValue = copyright
    }


    @IBAction func onGitHub(_ sender: Any) {
        NSWorkspace.open(HostsUrl.github)
    }
}
