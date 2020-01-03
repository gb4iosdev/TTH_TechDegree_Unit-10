//
//  RapidDownloadable.swift
//  NASA
//
//  Created by Gavin Butler on 31-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

protocol RapidDownloadable {
    var imageURL: URL { get }
    var imageDownloadState: ImageDownloadState { get set }
    var image: UIImage? { get set }
}
