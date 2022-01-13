//
//  Hosts.swift
//  HostsX
//
//  Created by zm on 2021/12/3.
//

import Foundation
import AppKit

enum HostsStatus: Codable {
    
    case unknown, available, unavailable
 
    var color: NSColor {
        switch self {
        case .unknown: return .systemGray
        case .available: return .accent
        case .unavailable: return .systemPink
        }
    }
    
    var description: String {
        switch self {
        case .unknown: return Localization.Hosts.unknown
        case .available:  return Localization.Hosts.available
        case .unavailable: return Localization.Hosts.unavailable
        }
    }
}


class Hosts: Codable {
    
    let alias: String, url: String
    var isOrigin: Bool
    var status: HostsStatus = .unknown

    var isAvailable: Bool {
        .available == status
    }

    init(_ alias: String, url: String, isOrigin: Bool = false) {
        self.alias = alias
        self.url = url
        self.isOrigin = isOrigin
    }
    
}
