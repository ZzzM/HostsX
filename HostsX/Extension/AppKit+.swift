//
//  AppKit+.swift
//  HostsX
//
//  Created by zm on 2021/12/15.
//

import AppKit

extension Bundle {

    var identifier: String {
        bundleIdentifier ?? "com.alpha.hostsx"
    }

    var bundleName: String? {

        infoDictionary?["CFBundleName"] as? String
    }

    var version: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var commitHash: String? {
        infoDictionary?["CommitHash"] as? String
    }

    var commitDate: String? {
        infoDictionary?["CommitDate"] as? String
    }
    
    var humanReadableCopyright: String? {
        infoDictionary?["NSHumanReadableCopyright"] as? String
    }

}

extension NSWorkspace {
    class func open(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        shared.open(url)
    }
}


extension NSTableView {

    func makeView<T: NSTableCellView>(type: T.Type) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(rawValue: T.className)
        return makeView(withIdentifier: identifier, owner: self) as? T
    }

    func setup() {
        headerView = .none
    }

    func move(at row: Int) {

        _move(at: row)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            reloadData()
        }
    }

    func remove(at row: Int) {
        _remove(at: row)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            reloadData()
        }
    }

    func insert() {
        _insert(at: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            reloadData()
        }
    }


    private func _insert(at row: Int) {
        beginUpdates()
        insertRows(at: IndexSet(integer: row), withAnimation: .slideLeft)
        endUpdates()
    }

    private func _remove(at row: Int) {
        beginUpdates()
        removeRows(at: IndexSet(integer: row), withAnimation: .slideRight)
        endUpdates()
    }

    private func _move(at row: Int) {
        beginUpdates()
        moveRow(at: row, to: 0)
        endUpdates()
    }

}

extension NSView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get { layer?.cornerRadius ?? 0 }
        set {
            wantsLayer = true
            layer?.masksToBounds = true
            layer?.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
}


extension NSViewController {

    func setWindowContent(_ controller: NSViewController?) {
        view.window?.contentViewController = controller
    }

    func showAlert(_ title: String? = .none, message: String? = .none) {
        HXAlert.show(title: title, message: message)
    }

}

extension NSStoryboard {
    func instantiateController<T: NSViewController>(_ type: T.Type) -> T? {
        instantiateController(withIdentifier: type.className) as? T
    }

}

extension NSStatusItem {

    func setMenuBarIcon() {
        guard let icon = NSImage(named: NSImage.Name("menuBarIcon")) else { return }
        icon.isTemplate = true
        icon.size = CGSize(width: 16, height: 16)
        button?.image = icon
    }

}
