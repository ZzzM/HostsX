//
//  RemoteConfigController.swift
//  HostsX
//
//  Created by zm on 2021/12/2.
//

import Cocoa

class RemoteConfigController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!

    @IBOutlet weak var aliasLabel: NSTextField!
    
    @IBOutlet weak var statusLabel: NSTextField!

    @IBOutlet weak var originButton: NSButton!

    @IBOutlet var remoteMenu: NSMenu!
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        RemoteSource.cancel()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setup()
        showHosts()
        setupMenu()
    }

    @IBAction func onSetAsOrigin(_ sender: Any) {
        let message = Localization.Remote.hostsConfirmOrigin(RemoteSource.currentAlias)
        showConfirm(message) { [self] in
            RemoteSource.setAsOrigin()
            originButton.isHidden = true
            tableView.moved()
        }
    }

    @objc func open() {
        let message = Localization.Remote.hostsConfirmOpen(RemoteSource.currentAlias)
        showConfirm(message, completion: RemoteSource.open)
    }

    @objc func remove() {
        let message = Localization.Remote.hostsConfirmRemove(RemoteSource.currentAlias)
        showConfirm(message) { [self] in
            let row = RemoteSource.removed()
            tableView.removed(row)
        }
    }

    @objc func insert() {
        HostsConfigController.show(self) { [self] in
            RemoteSource.insert($0, urlString: $1)
            tableView.inserted()
        }
    }

}

extension RemoteConfigController {

    private func setupMenu() {
        remoteMenu.addImageItem(.link, action: #selector(open))
        remoteMenu.addImageItem(.add, action: #selector(insert))
        remoteMenu.addImageItem(.trash, action: #selector(remove))
    }

    private func showHosts() {
        RemoteSource.check { hosts in
            DispatchQueue.main.async { [weak self] in
                guard let strong = self else { return }
                strong.aliasLabel.stringValue = hosts.alias
                strong.statusLabel.backgroundColor = hosts.status.color
                strong.statusLabel.stringValue = hosts.status.description
                strong.originButton.isHidden = !RemoteSource.canSetAsOrigin
            }
        }
    }

}

extension RemoteConfigController: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        RemoteSource.rows
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(type: HostsURLCell.self) else { return .none }
        cell.hosts = RemoteSource[row]
        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let _tableView = notification.object as? NSTableView else { return }
        RemoteSource.select(_tableView.selectedRow)
        showHosts()
    }

}

extension RemoteConfigController: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        RemoteSource.select(tableView.clickedRow)
        remoteMenu.item(at: 1)?.isHidden = !RemoteSource.canAdd
        remoteMenu.item(at: 2)?.isHidden = !RemoteSource.canRemove
    }
}
