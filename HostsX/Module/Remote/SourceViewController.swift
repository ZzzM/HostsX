//
//  HostsConfigController.swift
//  HostsX
//
//  Created by zm on 2021/12/6.
//

import Cocoa

class SourceViewController: NSViewController {

    @IBOutlet weak var tagLabel: NSTextField!
    @IBOutlet weak var urlLabel: NSTextField!
    @IBOutlet weak var tagPrompt: NSTextField!
    @IBOutlet weak var urlPrompt: NSTextField!

    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!

    @IBOutlet weak var tagFiled: NSTextField!
    @IBOutlet weak var urlFiled: NSTextField!


    var source: Source?
    var addCompletion: SourceClosure?
    var editCompletion: SourceClosure?

    private var isAdding: Bool { nil == source }


    override func viewDidLoad() {
        super.viewDidLoad()
        tagLabel.stringValue = L10n.Source.tag
        urlLabel.stringValue = L10n.Source.url
        saveButton.title = L10n.Button.save
        cancelButton.title = L10n.Button.cancel

        if let source {
            tagFiled.stringValue = source.tag
            urlFiled.stringValue = source.url
        } else {
            tagFiled.placeholderString = L10n.Source.tagPlaceholder
            urlFiled.placeholderString = L10n.Source.urlPlaceholder
        }

        tagPrompt.stringValue = L10n.Source.tagHint
    }



    @IBAction func saveAction(_ sender: Any) {

        let tag = tagFiled.stringValue, urlString = urlFiled.stringValue

        if tag.isEmpty {
            return showAlert(L10n.Source.tagEmpty)
        }

        guard 3...8 ~= tag.count else {
            return showAlert(L10n.Source.tagInvalid)
        }

        if isAdding, DataSource.containsTag(tag) {
            return showAlert(L10n.Source.tagExists)
        }

        if urlString.isEmpty {
            return showAlert(L10n.Source.urlEmpty)
        }

        guard urlString.lowercased().contains("http://") || urlString.lowercased().contains("https://")  else {
            return showAlert(L10n.Source.urlInvalid)
        }

        guard URL(string: urlString) != .none else  {
            return showAlert(L10n.Source.urlInvalid)
        }

        if isAdding, DataSource.containsUrl(urlString) {
            return showAlert(L10n.Source.urlExists)
        }


        if let source {
            source.tag = tag; source.url = urlString
            editCompletion?(source)
        } else {
            let newSource = Source(tag, url: urlString)
            addCompletion?(newSource)
        }


        dismiss(.none)
    }

}



