//
//  HXError.swift
//  HostsX
//
//  Created by zm on 2021/12/20.
//

import Foundation

enum HXError: Error, LocalizedError {
    case invalidURL,
         scriptCompilation,
         scriptExcution(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return L10n.Error.invalidURL
        case .scriptCompilation: return L10n.Error.scriptCompilation
        case .scriptExcution(let message): return "\(L10n.Error.scriptExcution) \(message)"
        }
    }
}


