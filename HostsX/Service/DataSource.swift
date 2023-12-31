//
//  DataSource.swift
//  HostsX
//
//  Created by zm on 2021/12/7.
//

import Foundation
import AppKit

struct DataSource {

    private enum DataSourceKey {
        static let data = "dataSourceKey.data"
    }

    private static let mockData = [
        Source("Soure01", url: HXURL.test)
    ]

    private static var data: [Source] {
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: DataSourceKey.data)
            }
        }
        get {
            guard let data = UserDefaults.standard.value(forKey: DataSourceKey.data) as? Data else {
                return []
            }
            let decoder = JSONDecoder()
            if let result = try? decoder.decode([Source].self, from: data) {
                return result
            }
            return []
        }
    }

    static var `default`: Source? { data.first(where: \.isDefault) }

    static var current: Source?

    static var currentRow: Int? {
        data.firstIndex { current?.id == $0.id }
    }


    static var isEmpty: Bool { data.isEmpty }
    
    static var rows: Int { data.count }

    static var canAdd: Bool {  rows < 10 }

    static var canUpdate: Bool {
        data.isEmpty ? false: data.contains(where: \.isDefault)
    }
}


extension DataSource {

    static subscript(_ row: Int) -> Source? {
        get { data[row] }
        set { if let newValue { data[row] = newValue } }
    }

    static func cancel() { Network.cancel() }

    static func remove(at row: Int) {
        data.remove(at: row)
    }


    static func insert(_ source: Source) {
        data.insert(source, at: 1)
    }

    static func append(_ source: Source) {
        data.append(source)
    }

    static func update(_ source: Source) {
        if let currentRow {
            self[currentRow] = source
        }
    }

    static func setDefault(at row: Int) {

        guard let source = self[row] else { return }

        data.remove(at: row)
        data.insert(source, at: 0)

        for (row, source) in data.enumerated() {
            source.isDefault = 0 == row
            self[row] = source
        }

    }

    static func restore() {
        data = mockData
    }

    static func open() {
        guard let current else { return }
        NSWorkspace.open(current.url)
    }

    static func containsTag(_ tag: String) -> Bool {
        data.contains{ tag == $0.tag }
    }

    static func containsUrl(_ url: String) -> Bool {
        data.contains{ url == $0.url }
    }
}

