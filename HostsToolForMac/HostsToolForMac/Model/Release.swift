//
//  Repo.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/21.
//  Copyright © 2018年 ZzzM. All rights reserved.
//
struct Release: Codable {
    let name: String
    let tag_name: String
    
    var status: VersionStatus {
        return tag_name.isLatest ?
            .latest : .available
    }
}

extension String {
    
    var intVersion: Int {
        if let value = Int(replacingOccurrences(of: ".", with: "")) {
            return value
        }
        return  -1
    }
    
    var isLatest: Bool{
        guard intVersion != -1 else {
            return true
        }
        return AppVersion.intVersion >= self.intVersion
    }
    
}
