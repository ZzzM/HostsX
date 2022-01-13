//
//  Dialog.swift
//  HostsX
//
//  Created by zm on 2021/12/6.
//

import Foundation
import AppKit


struct Dialog {

    static func showConfirm(from: NSViewController, message: String,  completion: @escaping VoidClosure) {
        from.presentAsSheet(ConfirmDialogController(message, completion: completion))
    }

    static func showInfo(from: NSViewController, message: String) {
        from.presentAsSheet(InfoDialogController(message: message))
    }
}
