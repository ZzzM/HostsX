//
//  Hosts.swift
//  HostsToolForMac
//
//  Created by zm on 2019/12/31.
//  Copyright © 2019 ZzzM. All rights reserved.
//
import Foundation

enum HostsType: Int, CaseIterable {
    case coding = 1, gogs, github
    
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
            return .coding
        }
    }
    
    static var names: [String] {
        return HostsType.allCases.map{$0.name}
    }
    
    var name: String {
        switch self {
        case .coding:
            return "Coding"
        case .gogs:
            return "Gogs"
        default:
            return "Github"
        }
    }
    
    var url: URL {
        switch self {
        case .coding:
            return URL(string:"https://scaffrey.coding.net/p/hosts/d/hosts/git/raw/master/hosts-files/hosts")!
        case .gogs:
            return URL(string:"https://git.qvq.network/googlehosts/hosts/raw/master/hosts-files/hosts")!
        default:
            return URL(string:"https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts")!
        }
    }
    
}

extension String {
    var hostsType: HostsType {
        return HostsType.allCases.first {
            $0.name == self
        } ?? .coding
    }
}
