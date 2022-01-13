//
//  AppKit+.swift
//  HostsX
//
//  Created by zm on 2021/12/15.
//

import AppKit

extension Bundle {
    var bundleName: String? {
        infoDictionary?["CFBundleName"] as? String
    }

    var shortVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var version: String? {
        infoDictionary?["CFBundleVersion"] as? String
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
        select(0)
    }

    func moved() {
        move(selectedRow)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            reloadData()
            select(0)
        }
    }

    func removed(_ row: Int) {
        remove(row)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            reloadData()
            select(0)
        }
    }

    func inserted() {
        insert(1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            reloadData()
            select(1)
        }
    }

    private func select(_ row: Int) {
        selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
    }

    private func insert(_ row: Int) {
        beginUpdates()
        insertRows(at: IndexSet(integer: row), withAnimation: .slideLeft)
        endUpdates()
    }

    private func remove(_ row: Int) {
        beginUpdates()
        removeRows(at: IndexSet(integer: row), withAnimation: .slideRight)
        endUpdates()
    }

    private func move(_ row: Int) {
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

extension NSImageView {
    func addShadow() {
        let shadow = NSShadow()
        shadow.shadowOffset = .init(width: 2, height: -2)
        shadow.shadowColor = .lightGray
        shadow.shadowBlurRadius = 3
        self.shadow = shadow
    }
}

extension NSViewController {

    func setWindowContent(_ controller: NSViewController?) {
        view.window?.contentViewController = controller
    }

    func showConfirm(_ message: String, completion: @escaping VoidClosure) {
        Dialog.showConfirm(from: self, message: message, completion: completion)
    }

    func showInfo(_ message: String) {
        Dialog.showInfo(from: self, message:message)
    }

}

extension NSStoryboard {
    func instantiateController<T: NSViewController>(_ type: T.Type) -> T? {
        instantiateController(withIdentifier: type.className) as? T
    }

}

extension NSMenu {
    func addImageItem(_ name: NSImage.Name, action: Selector?) {
        let item = NSMenuItem(title: "", action: action, keyEquivalent: "")
        let image = NSImage(named: name)
        image?.isTemplate = true
        item.image = image
        addItem(item)
    }
}

extension NSMenuItem {
    func setAttributedTitle(_ title: String) {
        attributedTitle = NSAttributedString(string: title, attributes: Attributes.menu)
    }
}

extension NSStatusItem {
    func setAttributedTitle(_ title: String?) {
        guard title != nil else { return }
        button?.attributedTitle = NSAttributedString(string: title!, attributes: Attributes.menu)
    }
}

extension Optional where Wrapped == NSWindowController {
    mutating func show(_ content: NSStoryboard) {
        self?.close()
        self = content.instantiateInitialController() as? NSWindowController
        self?.showWindow(.none)
        NSApp.activate(ignoringOtherApps: true)
    }
}
