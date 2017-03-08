//
//  Network.swift
//  Host
//
//  Created by Zhang.M on 2017/2/16.
//  Copyright © 2017年 Misaka. All rights reserved.
//

import Cocoa
import SwiftyJSON


typealias completionBlock = (Bool, Error?)->Void

class Network: NSObject {
    
    class func requestCheckVersion(block: @escaping completionBlock){
        
        URLSession.shared.dataTask(with: URLComponents(string: Utils.kProjectReleasesLink)!.url!, completionHandler: {
            (data, response, error) in
            guard let _: Data = data else {
                return block(false,error)
            }
            if error != nil {
               return block(false,error)
            } else {
                for (_,subJson):(String, JSON) in JSON(data: data!) {
                    let model = RepoModel(jsonObject: subJson)
                    if Utils.kProjectName == model.name {
                        return block(Utils.checkVersoin(newestVersion: model.tag_name),error)
                    }
                }
            }
        }).resume()
        
    }
    
}
