//
//  ImageDownloadState.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Capture download state to avoid duplicate fetching
enum ImageDownloadState {
    case placeholder
    case downloaded
    case failed
}
