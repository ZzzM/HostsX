//
//  RepoModel.swift
//  Host
//
//  Created by Zhang.M on 2017/2/16.
//  Copyright © 2017年 Misaka. All rights reserved.
//

import Cocoa
import SwiftyJSON
struct RepoModel {

    // Original json object
    fileprivate let originalJson: JSON
    
    // Model property
    let name: String
    let tag_name:String
   
    
    init(jsonObject json: JSON) {
        
        // Set property
        name = json["name"].stringValue
        tag_name = json["tag_name"].stringValue
        originalJson = json
    }
}
