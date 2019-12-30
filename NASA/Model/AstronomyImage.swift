//
//  AstronomyImage.swift
//  NASA
//
//  Created by Gavin Butler on 30-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

class AstronomyImage: Codable {
    let title: String
    let date: String
    let url: URL
    let explanation: String
    let hdurl: URL
    let copyright: String
}
