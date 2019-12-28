//
//  RoverPhoto.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import Foundation

class RoverPhoto: Codable {
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


