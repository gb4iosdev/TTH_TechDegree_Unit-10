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
    let earthDate: String
    var image: UIImage?
    var imageDownloadState: ImageDownloadState = .placeholder
    
    enum CodingKeys: String, CodingKey {
        case id
        case earthDate = "earth_date"
    }
}
