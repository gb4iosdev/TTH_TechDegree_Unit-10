//
//  NASAEndpoint.swift
//  NASA
//
//  Created by Gavin Butler on 13-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

enum NASAEndpoint {
    case marsRoverPhotos(rover: Rover, camera: Camera, date: Date)
    case earthImage(latitude: Double, longitude: Double)
    case astronomyImage(date: Date?)
    //case image(urlString: String)                    //provided as a full URL String
}

//conforms to the Endpoint protocol to assist with URL creation.
extension NASAEndpoint: Endpoint {
    var path: String {
        switch self {
        case .marsRoverPhotos(let rover, _, _):
            return "/mars-photos/api/v1/rovers/" + rover.rawValue + "/photos"
        case .earthImage:
            return "/planetary/earth/imagery/"
        case .astronomyImage:
            return "/planetary/apod"
        //case .image: return ""
        }
    }
    
    var queryParameters: [URLQueryItem] {
        
        var result = [URLQueryItem]()
        let apiKey = "4Ye02d6tWRNIZvP5a9RMOnFbePacsNy6ZfwIcW9l"
        
        switch self {
        //Main Discover query for movie fetches.
        case .marsRoverPhotos(_, let camera, let date):
            //Add the query items
            if camera != .all {     //All camera option means that the query item should be excluded altogether
                let cameraQueryItem = URLQueryItem(name: ParameterKey.camera.rawValue, value: camera.rawValue)
                result.append(cameraQueryItem)
            }
            let dateQueryItem = URLQueryItem(name: ParameterKey.earthDate.rawValue, value: date.asEarthDate())
            result.append(dateQueryItem)
        case .earthImage(let latitude, let longitude):
            let latitudeQueryItem = URLQueryItem(name: ParameterKey.latitude.rawValue, value: String(Float(latitude)))
            result.append(latitudeQueryItem)
            let longitudeQueryItem = URLQueryItem(name: ParameterKey.longitude.rawValue, value: String(Float(longitude)))
            result.append(longitudeQueryItem)
            let cloudScoreQueryItem = URLQueryItem(name: ParameterKey.cloudScore.rawValue, value: "true")
            result.append(cloudScoreQueryItem)
        case .astronomyImage(let date):
            if let photoDate = date {
                let dateQueryItem = URLQueryItem(name: ParameterKey.date.rawValue, value: photoDate.asEarthDate())
                result.append(dateQueryItem)
            }
        
        //Image query handled separately.
//        case .image:
//            break
        }
        result.append(URLQueryItem(name: ParameterKey.apiKey.rawValue, value: apiKey))
        return result
    }
    
    var base: String {
        return "https://api.nasa.gov"
    }
    
//    //Image request handled separately to bypass QueryParameters creation.  No parameters required for this endpoint.
//    func requestForImage() -> URLRequest? {
//        switch self {
//        case .image(let urlString):
//            let url = URL(string: urlString)!
//            return URLRequest(url: url)
//        default:    return nil
//        }
//    }
}
