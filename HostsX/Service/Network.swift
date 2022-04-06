//
//  File.swift
//  HostsX
//
//  Created by zm on 2021/12/2.
//

import Foundation

struct Network {

    private static var task: URLSessionDataTask?

    static func check(_ urlString: String, completion: @escaping (HostsStatus) -> Void){

        completion(.unknown)

        cancel()

        guard let url = URL(string: urlString) else {
            return completion(.unavailable)
        }


        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)

        task = URLSession.shared.dataTask(with: request) {  data, response, error in
            if let error = error {
                return completion(error.isCancelled ? .unknown : .unavailable)
            }

            guard let response = response as? HTTPURLResponse else  {
                return completion(.unavailable)
            }
            guard  200 == response.statusCode else {
                return completion(.unavailable)
            }
            return completion(.available)
        }

        task?.resume()

    }

    static func cancel() {
        task?.cancel()
    }
}


