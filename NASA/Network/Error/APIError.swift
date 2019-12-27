//
//  APIError.swift
//  NASA
//
//  Created by Gavin Butler on 20-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

enum APIError: Error {

    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
    case noDataReturnedFromDataTask(detail: String)

    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .invalidData: return "Invalid Data"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case . invalidURL: return "Invalid URL"
        case .noDataReturnedFromDataTask: return "No Data Returned From Fetch Task"
        }
    }
}
