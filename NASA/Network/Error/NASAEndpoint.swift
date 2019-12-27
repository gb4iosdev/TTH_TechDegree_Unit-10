//
//  NASAEndpoint.swift
//  NASA
//
//  Created by Gavin Butler on 13-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

enum NASAEndpoint {
    case marsRoverPhotos(rover: Rover, camera: Camera?, date: Date?)
    case image(imageId: String)                    //the part returned from poster_path on the movie
}

//conforms to the Endpoint protocol to assist with URL creation.
extension NASAEndpoint: Endpoint {
    var path: String {
        switch self {
        case .marsRoverPhotos(let rover, _, _):
            return "/mars-photos/api/v1/rovers/" + rover.rawValue + "/photos"
        case .image: return ""
        }
    }
    
    var queryParameters: [URLQueryItem] {
        
        var result = [URLQueryItem]()
        let apiKey = "4Ye02d6tWRNIZvP5a9RMOnFbePacsNy6ZfwIcW9l"
        
        switch self {
        //Main Discover query for movie fetches.
        case .marsRoverPhotos(_, let camera, let date):
            //Add the query items if present
            if let camera = camera {
                let cameraQueryItem = URLQueryItem(name: ParameterKey.camera.rawValue, value: camera.rawValue)
                result.append(cameraQueryItem)
            }
            if let date = date {
                let dateQueryItem = URLQueryItem(name: ParameterKey.date.rawValue, value: "2015-11-05") //date.asEarthDate()
                result.append(dateQueryItem)
            }
            result.append(URLQueryItem(name: ParameterKey.apiKey.rawValue, value: apiKey))
        //Image query handled separately.
        case .image:
            break
        }
        
        return result
    }
    
    var base: String {
        switch self {
        case .image:        return ""
        default:            return "https://api.nasa.gov"
        }
    }
    
    //Image request handled separately to bypass QueryParameters creation.  No parameters required for this endpoint.
    func requestForImage() -> URLRequest? {
        switch self {
        case .image(let imageId):
            var components = URLComponents(string: base)!
            components.path = path + imageId
            return URLRequest(url: components.url!)
        default:    return nil
        }
    }
}
