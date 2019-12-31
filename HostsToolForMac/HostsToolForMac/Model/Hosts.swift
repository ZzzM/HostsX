//
//  Hosts.swift
//  HostsToolForMac
//
//  Created by zm on 2019/12/31.
//  Copyright © 2019 ZzzM. All rights reserved.
//
import Foundation

enum HostsType: Int, CaseIterable {
    case
    code = 1,
    github
    
    static var current: HostsType! {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "HostsSourceType")
            UserDefaults.standard.synchronize()
        }
        get {
            let rawValue = UserDefaults.standard.integer(forKey: "HostsSourceType")
            if rawValue > 0 {
                return HostsType(rawValue: rawValue)
            }
            return .code
        }
    }
    
    var name: String {
        switch self {
        case .code:
            return "Code"
        default:
            return "Github"
        }
    }
    
    var url: URL {
        switch self {
        case .code:
            return CodeSourceURL
        default:
            return GithubSourceURL
        }
    }
    
}

extension String {
    var hostsType: HostsType {
        return HostsType.allCases.first {
            $0.name == self
        } ?? .code
    }
}
