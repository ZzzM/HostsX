//
//  Constant.swift
//  HostsToolForMac
//
//  Created by zm on 2019/11/14.
//  Copyright © 2019 ZzzM. All rights reserved.
//

import Cocoa

typealias FailureHandler = (Error) -> Void

let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

let ApiReleasesURL = URL(string: "https://api.github.com/repos/ZzzM/HostsToolforMac/releases/latest")!
let AppReleasesURL = URL(string: "https://github.com/ZzzM/HostsToolforMac/releases")!
let AppHomePageURL = URL(string: "https://github.com/ZzzM/HostsToolforMac")!

let StartMark = "# My Hosts Start"
let EndMark = "# My Hosts End"
let ShowMark = "🤓"

let TargetDirectory = NSSearchPathForDirectoriesInDomains(
    .cachesDirectory,
    .userDomainMask,
    true)
    .first!

let TargetPath = TargetDirectory + "/hosts"
