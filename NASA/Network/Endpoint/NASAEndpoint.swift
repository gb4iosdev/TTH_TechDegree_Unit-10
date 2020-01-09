//
//  NASAEndpoint.swift
//  NASA
//
//  Created by Gavin Butler on 13-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Encapsulate endpoints for the 3 main app areas:
enum NASAEndpoint {
    case marsRoverPhotos(rover: Rover, camera: Camera, date: Date)
    case earthImage(latitude: Double, longitude: Double)
    case astronomyImage(date: Date?)
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
        }
    }
    
    var queryParameters: [URLQueryItem] {
        
        var result = [URLQueryItem]()
        let apiKey = "4Ye02d6tWRNIZvP5a9RMOnFbePacsNy6ZfwIcW9l"
        
        switch self {
        //Build Parameter lists (Query Items) with reference to the ParameterKey Class.
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
        }
        //API Key is required in all urls for the NASA API
        result.append(URLQueryItem(name: ParameterKey.apiKey.rawValue, value: apiKey))
        return result
    }
    
    var base: String {
        return "https://api.nasa.gov"
    }
}
