//
//  Networker.swift
//  NASA
//
//  Created by Gavin Butler on 07-01-2020.
//  Attribution - Dennis Parussini from TTH TD Slack "chit-chat" channel 
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

//Data Fetcher that simply fetches asynchronously, determines if result is a success or fail, and passes back according.  Type agnostic – no parsing here.
class Networker {
    static func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
