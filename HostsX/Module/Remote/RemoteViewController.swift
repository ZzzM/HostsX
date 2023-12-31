//
//  RemoteViewController.swift
//  HostsX
//
//  Created by zm on 2021/12/2.
//

import Cocoa

class RemoteViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!

    @IBOutlet weak var addButton: NSButton!

    @IBOutlet weak var refreshButton: NSButton!

    @IBOutlet weak var openItem: NSMenuItem!
    @IBOutlet weak var editItem: NSMenuItem!
    @IBOutlet weak var removeItem: NSMenuItem!

    @IBOutlet weak var circularIndicator: NSProgressIndicator!
    
    @IBOutlet weak var noLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //DataSource.restore()
        tableView.setup()

        setup()
        update()

    }

//MARK: Menu Actions
    @IBAction func openAction(_ sender: Any) {
        DataSource.open()
    }

    @IBAction func editAction(_ sender: Any) {
        performSegue(withIdentifier: SourceViewController.className,
                     sender: DataSource.current)
    }

    @IBAction func removeAction(_ sender: Any) {

        guard let tag = DataSource.current?.tag else { return }
        let message = L10n.Remote.remove(tag)
        let titles = [L10n.Button.remove, L10n.Button.cancel]
        let response = HXAlert.show(title: message, buttonTitles: titles)
        guard .alertFirstButtonReturn == response else {
            return
        }
        guard let row = DataSource.currentRow else { return }

        DataSource.remove(at: row)
        tableView.remove(at: row)
        update()

    }

//MARK: Other Actions
    private func setDefault(_ row: Int) {
        DataSource.setDefault(at: row)
        tableView.move(at: row)
        update()
    }

    @IBAction func refreshAction(_ sender: Any) {

        circularIndicator.startAnimation(sender)
        refreshButton.isHidden = true

        FileHelper.remoteUpdate { error in
            self.circularIndicator.stopAnimation(sender)
            self.refreshButton.isHidden = false

            guard let error else { return }
            HXAlert.showError(error)
        }

    }
    
    @IBAction func addAction(_ sender: Any) {

        if DataSource.canAdd {
            performSegue(withIdentifier: SourceViewController.className,
                         sender: .none)
        } else {
            showAlert(L10n.Remote.max)
        }


    }
    
}

extension RemoteViewController {


    private func setup() {


        let attributes = [NSAttributedString.Key.foregroundColor: NSColor.red]

        openItem.title = L10n.Button.open
        editItem.title = L10n.Button.edit
        removeItem.attributedTitle = NSAttributedString(string: L10n.Button.remove,
                                                        attributes: attributes)

        noLabel.stringValue = L10n.Remote.no
        tableView.backgroundColor = .background

        circularIndicator.isDisplayedWhenStopped = false

    }

    private func update() {
        refreshButton.isHidden = !DataSource.canUpdate
        noLabel.isHidden = !DataSource.isEmpty
    }

    private func showMenu(_ row: Int) {
        DataSource.current = DataSource[row]
    }

}


extension RemoteViewController: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        DataSource.rows
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(type: SourceCellView.self) else { return .none }
        cell.source = DataSource[row]
        cell.showMenu = { [weak self] in
            guard let self else { return }
            self.showMenu(row)
        }
        cell.setDefault = { [weak self] in
            guard let self else { return }
            self.setDefault(row)
        }
        return cell
    }


}

extension RemoteViewController {
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let destination = segue.destinationController as? SourceViewController else {
                  return
        }
        if let source = sender as? Source {
            destination.source = source
            destination.editCompletion = { [weak self] in
                guard let self else { return }
                self.editSource($0)
            }
        } else {
            destination.addCompletion = { [weak self] in
                guard let self else { return }
                self.addSource($0)
            }
        }

    }

    private func addSource(_ source: Source) {
        if DataSource.isEmpty {
            DataSource.append(source)
            tableView.reloadData()
            update()
        } else {
            DataSource.insert(source)
            tableView.insert()
        }
    }

    private func editSource(_ source: Source) {
        DataSource.update(source)
        tableView.reloadData()
    }
}
