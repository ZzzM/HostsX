//
//  ConfirmDialogController.swift
//  HostsX
//
//  Created by zm on 2021/12/5.
//

import Cocoa

class ConfirmDialogController: NSViewController {

    let message: String, completion: VoidClosure?

    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var doneButton: NSButton!
    @IBOutlet weak var messageLabel: NSTextFieldCell!
    
    init(_ message: String, completion: VoidClosure?) {
        
        self.message = message
        self.completion = completion
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
        cancelButton.title = Localization.Dialog.cancel
    }


    @IBAction func onDismiss(_ sender: Any) {
        dismiss(.none)
    }

    @IBAction func onDone(_ sender: Any) {
        completion?()
        dismiss(.none)
    }

}
