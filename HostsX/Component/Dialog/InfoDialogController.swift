//
//  InfoDialogController.swift
//  HostsX
//
//  Created by zm on 2021/12/6.
//

import Cocoa

class InfoDialogController: NSViewController {

    let message: String

    @IBOutlet weak var messageLabel: NSTextFieldCell!

    @IBOutlet weak var doneButton: NSButton!

    init(message: String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = .dialog
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.stringValue = message
        doneButton.title = Localization.Dialog.done
    }

    @IBAction func onDone(_ sender: Any) {
        dismiss(.none)
    }
    
}

