//
//  AstronomyImage.swift
//  NASA
//
//  Created by Gavin Butler on 30-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class AstronomyPhoto: Codable, RapidDownloadable {
    let title: String
    let date: String
    let imageURL: URL
    var image: UIImage?
    var imageDownloadState: ImageDownloadState = .placeholder
    let explanation: String
    let hdurl: URL?
    let copyright: String?
    let mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case imageURL = "url"
        case explanation
        case hdurl
        case copyright
        case mediaType = "media_type"
    }
}
