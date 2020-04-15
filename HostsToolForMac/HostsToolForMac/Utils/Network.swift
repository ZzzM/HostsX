//
//  Network.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/21.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa



struct Network {
    
    static func checkVersion(result: @escaping (VersionStatus) -> ()) {
        
        request(url: ApiReleasesURL,
                success:  {
                    do {
                        let release = try JSONDecoder().decode(Release.self, from: $0)
                        result(release.status)
                    } catch {
                        result(VersionStatus.error(error.localizedDescription))
                    }
        },
                failure: {
                    result(VersionStatus.error($0.localizedDescription))
        })
        
    }
    
    
    private static func request(url: URL,
                                success: ((Data) -> Void)? = .none,
                                failure: FailureHandler? = .none) {
        URLSession.shared
            .dataTask(with: url) { (data, response, error) in
                if error != nil {
                    failure? (error!)
                    return
                }
                
                if data != nil {
                    success? (data!)
                }
                
        }.resume()
    }

}
