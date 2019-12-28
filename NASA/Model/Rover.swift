//
//  Rover.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

enum Rover: String {
    case curiosity
    case opportunity
    case spirit
    
    //Returns the cameras equiped on the specified Rover
    var cameras: [Camera] {
        switch self {
        case .curiosity:
            return [.fhaz, .rhaz, .mast, .chemcam, .mahli, .mardi, .navcam]
        case .opportunity:
            return [.fhaz, .rhaz, .navcam, .pancam, .minites]
        case .spirit:
            return [.fhaz, .rhaz, .navcam, .pancam, .minites]
        }
    }
}
