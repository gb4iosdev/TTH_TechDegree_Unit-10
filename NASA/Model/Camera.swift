//
//  Camera.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Camer names and long descriptions for all cameras found on the 3 mars rovers
enum Camera: String {
    case all
    case fhaz
    case rhaz
    case mast
    case chemcam
    case mahli
    case mardi
    case navcam
    case pancam
    case minites
    
    var description: String {
        switch self {
        case .all:      return "All Cameras"
        case .fhaz:     return "Front Hazard Avoidance Camera"
        case .rhaz:     return "Rear Hazard Avoidance Camera"
        case .mast:     return "Mast Camera"
        case .chemcam:  return "Chemistry and Camera Complex"
        case .mahli:    return "Mars Hand Lens Imager"
        case .mardi:    return "Mars Descent Imager"
        case .navcam:   return "Navigation Camera"
        case .pancam:   return "Panoramic Camera"
        case .minites:  return "Miniature Thermal Emission Spectrometer (Mini-TES)"
        }
    }
}
