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
        case .all:      return "ALL CAMERAS"
        case .fhaz:     return "FHAZ"
        case .rhaz:     return "RHAZ"
        case .mast:     return "MAST"
        case .chemcam:  return "CHEMCHAM"
        case .mahli:    return "MAHLI"
        case .mardi:    return "MARDI"
        case .navcam:   return "NAVCAM"
        case .pancam:   return "PANCAOM"
        case .minites:  return "MINI-TES"
        }
    }
}
