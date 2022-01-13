//
//  RemoteSource.swift
//  HostsX
//
//  Created by zm on 2021/12/7.
//

import Foundation
import AppKit

struct RemoteSource {

    private enum RemoteSourceKey {
        static let data = "remoteSourceKey.data"
    }

    private static let defaultData = [
        Hosts("Hosts01", url: HostsUrl.h1, isOrigin: true),
        Hosts("Hosts02", url: HostsUrl.h2)
    ]

    private static var data: [Hosts] {
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: RemoteSourceKey.data)
            }
        }
        get {
            guard let data = UserDefaults.standard.value(forKey: RemoteSourceKey.data) as? Data else {
                return defaultData
            }
            let decoder = JSONDecoder()
            if let result = try? decoder.decode([Hosts].self, from: data) {
                return result
            }
            return defaultData
        }
    }

    private static var row = 0
    private static var current: Hosts { self[row] }
    private static var origin: Hosts { data.first(where: {$0.isOrigin}) ?? data[0]}

    static var originUrl: String { origin.url }
    static var currentAlias: String { current.alias }
    static var rows: Int { data.count }

    static var canAdd: Bool {  rows <= 10 }
    static var canRemove: Bool { !current.isOrigin }
    static var canSetAsOrigin: Bool {  current.isAvailable && canRemove }

}


extension RemoteSource {

    static subscript(_ row: Int) -> Hosts {
        get { data[row] }
        set { data[row] = newValue }
    }

    static func cancel() { Network.cancel() }

    static func select(_ row: Int, completion: VoidClosure? = .none) {
        guard row > -1 else { return }
        self.row = row
        completion?()
    }

    static func check(completion: @escaping (Hosts) -> Void) {
        completion(current)
        Network.check(current.url) {
            let hosts = current
            hosts.status = $0
            self[row] = hosts
            completion(current)
        }
    }

    @discardableResult
    static func removed() -> Int {
        let _row = row
        data.remove(at: _row)
        row = 0
        return _row
    }

    
    static func insert(_ alias: String, urlString: String) {
        data.insert(Hosts(alias, url: urlString), at: 1)
        row = 1
    }

    static func setAsOrigin() {

        let hosts = current
        hosts.isOrigin.toggle()
        removed()

        for (i, val) in data.enumerated() {
            val.isOrigin.toggle()
            data[i] = val
        }

        data.insert(hosts, at: 0)
    }

    static func restore() {
        data = defaultData
        row = 0
    }

    static func open() {
        NSWorkspace.open(current.url)
    }

    static func containsAlias(_ alias: String) -> Bool {
        data.contains(where: {$0.alias == alias })
    }

    static func containsURL(_ url: String) -> Bool {
        data.contains(where: {$0.url == url })
    }
}

