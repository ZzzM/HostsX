//
//  Network.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/21.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa
import RxSwift


class Network: NSObject {

    static func checkVersion() -> Observable<Bool>{
        return URLSession.shared.rx
            .json(url: ApiReleasesURL)
            .catchError{Observable.error($0)}
            .map{
                
                let data = try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted)

                guard let release = try? JSONDecoder().decode(Release.self, from: data) else{
                    return true
                }
                return release.tag_name.needUpdate
        }
        
    }

}
