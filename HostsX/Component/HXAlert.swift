//
//  HXAlert.swift
//  HostsX
//
//  Created by zm on 2023/10/26.
//

import AppKit

struct HXAlert {

    @discardableResult
    static func show(title: String? = .none,
                     message: String? = .none,
                     buttonTitles: [String] = []) -> NSApplication.ModalResponse {
        let alert = NSAlert()
        for buttonTitle in buttonTitles {
            alert.addButton(withTitle: buttonTitle)
        }
        if let title {
            alert.messageText = title
        }
        if let message {
            alert.informativeText = message
        }
        return alert.runModal()
    }


    static func showError(_ error: Error) {
        let alert = NSAlert(error: error)
        alert.runModal()
    }
}
