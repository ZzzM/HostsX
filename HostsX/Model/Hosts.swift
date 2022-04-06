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
 
    var icon: NSImage {
        switch self {
        case .unknown: return .init(named: NSImage.statusNoneName)!
        case .available: return .init(named: NSImage.statusAvailableName)!
        case .unavailable: return .init(named: NSImage.statusUnavailableName)!
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
