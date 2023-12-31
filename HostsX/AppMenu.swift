//
//  AppMenu.swift
//  HostsX
//
//  Created by zm on 2021/12/17.
//

import Cocoa

class AppMenu: NSMenu {

    @IBOutlet weak var localItem: NSMenuItem!

    @IBOutlet weak var remoteItem: NSMenuItem!

    @IBOutlet weak var resetItem: NSMenuItem!
    @IBOutlet weak var aboutItem: NSMenuItem!

    @IBOutlet weak var quitItem: NSMenuItem!


    private lazy var remoteWC = windowController(from: .remote)
    private lazy var aboutWC = windowController(from: .about)

    override func awakeFromNib() {
        localItem.title = L10n.Menu.local
        remoteItem.title = L10n.Menu.remote
        resetItem.title = L10n.Menu.reset
        aboutItem.title = L10n.Menu.about
        quitItem.title = L10n.Menu.quit
    }

    @IBAction func localAction(_ sender: Any) {
        FileHelper.localUpdate { error in
            guard let error else { return }
            HXAlert.showError(error)
        }
    }

    @IBAction func remoteAction(_ sender: Any) {
        show(remoteWC)
    }


    @IBAction func resetAction(_ sender: Any) {
        let titles = [L10n.Button.reset, L10n.Button.cancel]
        let rsp = HXAlert.show(title: L10n.Menu.resetHint, buttonTitles: titles)
        guard .alertFirstButtonReturn == rsp else {
            return
        }

        FileHelper.reset { error in
            guard let error else { return }
            HXAlert.showError(error)
        }
    }

    @IBAction func onAbout(_ sender: Any) {
        show(aboutWC)
    }
    
}

extension AppMenu {

    func windowController(from: NSStoryboard) -> NSWindowController? {
        from.instantiateInitialController() as? NSWindowController
    }

    func show(_ windowController: NSWindowController?) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        windowController?.window?.orderFrontRegardless()
    }
}
