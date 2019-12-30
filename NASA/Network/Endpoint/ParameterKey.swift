//
//  ParameterKey.swift
//  NASA
//
//  Created by Gavin Butler on 13-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//List of parameter keys that can be used in this application, and their query string representations.
enum ParameterKey: String {
    //For Rover Photos
    case earthDate = "earth_date"
    case camera
    case apiKey = "api_key"
    case page
    //For Earth Imagery
    case longitude = "lon"
    case latitude = "lat"
    case cloudScore = "cloud_score"
}
