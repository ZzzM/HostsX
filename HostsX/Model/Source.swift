//
//  Source.swift
//  HostsX
//
//  Created by zm on 2021/12/3.
//

import Foundation
import AppKit


class Source: Codable {

    let id: UUID
    var tag, url: String, isDefault: Bool

    init(_ tag: String, url: String, isDefault: Bool = false) {
        self.id = UUID()
        self.tag = tag
        self.url = url
        self.isDefault = isDefault
    }
    
}
