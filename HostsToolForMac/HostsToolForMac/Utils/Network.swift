//
//  Network.swift
//  HostsToolForMac
//
//  Created by Zhang.M on 2018/5/21.
//  Copyright © 2018年 ZzzM. All rights reserved.
//

import Cocoa



struct Network {

    static func request(url: URL,
                                success: ((Data) -> Void)? = .none,
                                failure: FailureHandler? = .none) -> URLSessionTask {
        
        let task = URLSession.shared
            .dataTask(with: url) { (data, response, error) in
                if error != nil {
                    failure? (error!)
                    return
                }
                
                if data != nil {
                    success? (data!)
                }
                
        }
        
        task.resume()
        
        return task
    
    }

}
