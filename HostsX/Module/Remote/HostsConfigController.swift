//
//  HostsConfigController.swift
//  HostsX
//
//  Created by zm on 2021/12/6.
//

import Cocoa

class HostsConfigController: NSViewController {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var aliasLabel: NSTextField!
    @IBOutlet weak var urlLabel: NSTextField!
    @IBOutlet weak var aliasPrompt: NSTextField!
    @IBOutlet weak var urlPrompt: NSTextField!
    @IBOutlet weak var doneButton: NSButton!

    var completion: HostsClosure?, from: NSViewController?

    static func show(_ from: NSViewController?, completion: HostsClosure?) {
        let controller = NSStoryboard.remote.instantiateController(self)
        controller?.from = from
        controller?.completion = completion
        from?.setWindowContent(controller)
    }

    @IBOutlet weak var aliasFiled: NSTextField!
    @IBOutlet weak var urlFiled: NSTextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        aliasLabel.stringValue = Localization.Hosts.alias
        urlLabel.stringValue = Localization.Hosts.url
        doneButton.title = Localization.Remote.hostsOK
        titleLabel.stringValue = Localization.Remote.hosts
        aliasFiled.placeholderString = Localization.Remote.aliasPlaceholder
        urlFiled.placeholderString = Localization.Remote.urlPlaceholder
        aliasPrompt.stringValue = Localization.Remote.aliasPrompt
    }
    
    @IBAction func onBack(_ sender: Any) {
        setWindowContent(from)
    }

    @IBAction func onDone(_ sender: Any) {

        let alias = aliasFiled.stringValue, urlString = urlFiled.stringValue

        if alias.isEmpty {
            return showInfo(Localization.Remote.aliasPromptEmpty)
        }

        guard 3...8 ~=  alias.count else {
            return showInfo(Localization.Remote.aliasPromptInvalid)
        }

        if RemoteSource.containsAlias(alias) {
            return showInfo(Localization.Remote.aliasPromptExists)
        }

        if urlString.isEmpty {
            return showInfo(Localization.Remote.urlPromptEmpty)
        }

        guard urlString.contains("http://") || urlString.contains("https://")  else {
            return showInfo(Localization.Remote.urlPromptInvalid)
        }

        if RemoteSource.containsURL(urlString) {
            return showInfo(Localization.Remote.urlPromptExists)
        }
        setWindowContent(from)

        completion?(alias, urlString)
    }

}



