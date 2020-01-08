//
//  RoverPhotos.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Simple high level entity to match the format of data returned by the NASA API for Mars Rover Photos
class RoverPhotos: Codable {
    
    let photos: [RoverPhoto]
}
