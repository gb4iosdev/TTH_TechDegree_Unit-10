//
//  APIClient.swift
//  NASA
//
//  Created by Gavin Butler on 26-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

protocol APIClient {
    var decoder: JSONDecoder { get }
    var session: URLSession { get }
}

extension APIClient {
    
    //Fetch the data using a URL session object and attempt to convert to the type specified.  If successful, return via completion handler as associated value on result.success.  Else return error in result.error
    func fetchJSON<T: Codable>(with urlRequest: URLRequest, toType type: T.Type, completionHandler completion: @escaping (Result<T, APIError>) -> Void) {
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(Result.failure(.requestFailed))  //Can’t capture the response
                    return
                }
                if httpResponse.statusCode == 200 {
                    do {
                        let entity = try self.decoder.decode(type, from: data)
                        completion(Result.success(entity))
                    } catch {
                        completion(Result.failure(.jsonParsingFailure)) //Successful http status code, have data but can’t parse to the model.
                    }
                } else {
                    //Return the error
                    completion(Result.failure(.responseUnsuccessful(statusCode: httpResponse.statusCode)))
                }
            } else if let error = error {
                completion(Result.failure(.noDataReturnedFromDataTask(detail: error.localizedDescription))) //No data returned from session data task
            }
        }
        
        task.resume()
    }
}
