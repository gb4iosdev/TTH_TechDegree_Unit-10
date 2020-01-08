//
//  AstronomyImage.swift
//  NASA
//
//  Created by Gavin Butler on 30-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Captures Photo of the Day API data from the NASA API, in order to then access imageURL and hdurl paths to retrieve images
//Also tracks it's own image download state to support the asynchronous downloading.
class AstronomyPhoto: Codable, RapidDownloadable {
    let title: String
    let date: String
    let imageURL: URL
    var image: UIImage?
    var imageDownloadState: ImageDownloadState = .placeholder
    var hdurl: URL?
    var copyright: String?
    let mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case imageURL = "url"
        case hdurl
        case copyright
        case mediaType = "media_type"
    }
}
