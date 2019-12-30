//
//  EarthImage.swift
//  NASA
//
//  Created by Gavin Butler on 29-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class EarthImage: Codable {
    
    let id: String
    let imageDate: String
    let cloudScore: Double
    let url: URL
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageDate = "date"
        case cloudScore = "cloud_score"
        case url
    }
}
