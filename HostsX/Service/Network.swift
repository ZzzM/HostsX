//
//  File.swift
//  HostsX
//
//  Created by zm on 2021/12/2.
//

import Foundation

struct Network {

    private static var task: URLSessionDataTask?


    static func cancel() {
        task?.cancel()
    }
}


