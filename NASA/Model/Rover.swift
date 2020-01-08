//
//  Rover.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Rover enum to support compilation of correct URL endpoint for Mars Rover Photo retrieval
enum Rover: String {
    case curiosity
    case opportunity
    case spirit
    
    //Returns the cameras equiped on the specified Rover
    var cameras: [Camera] {
        switch self {
        case .curiosity:
            return [.all, .fhaz, .rhaz, .mast, .chemcam, .mahli, .mardi, .navcam]
        case .opportunity:
            return [.all, .fhaz, .rhaz, .navcam, .pancam, .minites]
        case .spirit:
            return [.all, .fhaz, .rhaz, .navcam, .pancam, .minites]
        }
    }
    
    //Returns landing date for rover - used to constrain date picker
    var landingDate: Date {
        switch self {
        case .curiosity:
            return Date.fromEarthDate("2012-08-06")!
        case .opportunity:
            return Date.fromEarthDate("2004-01-25")!
        case .spirit:
            return Date.fromEarthDate("2004-01-04")!
        }
    }
}
