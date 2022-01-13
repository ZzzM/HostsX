//
//  HostsError.swift
//  HostsX
//
//  Created by zm on 2021/12/20.
//

import Foundation

enum HostsError: Error, LocalizedError {
    case invalidHosts, invalidURL, compile, execute(String), cancelled

    var errorDescription: String? {
        switch self {
        case .invalidHosts: return Localization.Error.invalidHosts
        case .invalidURL: return Localization.Error.invalidURL
        case .compile: return Localization.Error.compile
        case .execute(let message): return "\(Localization.Error.execute) \(message)"
        case .cancelled: return Localization.Error.cancelled
        }
    }
}


