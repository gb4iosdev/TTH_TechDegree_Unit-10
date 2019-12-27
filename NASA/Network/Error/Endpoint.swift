//
//  Endpoint.swift
//  NASA
//
//  Created by Gavin Butler on 13-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
    var queryParameters: [URLQueryItem] { get }
}

//Default implementations in protocol extension
extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryParameters
        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
    
    //Reconstruct the query components in order to append a page number – for multi page ‘discover’ query
    func requestForPage(_ page: Int) -> URLRequest {
        var existingQueryParameters = queryParameters
        existingQueryParameters.append(URLQueryItem(name: ParameterKey.page.rawValue, value: String(page)))
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = existingQueryParameters
        return URLRequest(url: components.url!)
    }
}
