//
//  Network.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/21.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa
import RxSwift


struct Network {

    static var checkVersion: Observable<VersionStatus> {
        
        return URLSession.shared.rx
            .json(url: ApiReleasesURL)
            .catchError{ Observable.just(VersionStatus.error($0.localizedDescription))}
            .map{
                
                let data = try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted)

                guard let release = try? JSONDecoder().decode(Release.self, from: data) else{
                    return VersionStatus.latest
                }
                return release.tag_name.isLatest ?
                    VersionStatus.latest: VersionStatus.availble
        }
        
    }

}
