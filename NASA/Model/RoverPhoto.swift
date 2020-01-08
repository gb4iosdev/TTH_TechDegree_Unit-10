//
//  RoverPhoto.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Captures Rover Photo API data from the NASA API, in order to then access imageURL path to retrieve the corresponding image
//Also tracks it's own image download state to support the asynchronous downloading.
class RoverPhoto: Codable, RapidDownloadable {
    
    let id: Int
    let camera: Camera
    let earthDate: String
    let rover: Rover
    let imageURL: URL
    var image: UIImage?
    var imageDownloadState: ImageDownloadState = .placeholder
    
    enum CodingKeys: String, CodingKey {
        case id
        case camera
        case earthDate = "earth_date"
        case rover
        case imageURL = "img_src"
    }
    
    //Struct setup simply to capture the rover name from the JSON
    struct Rover: Codable {
        let name: String
    }
    
    //Struct setup simply to capture the camera short name from the JSON
    struct Camera: Codable {
        let name: String
    }
}


