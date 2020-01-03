//
//  RoverPhotoDownloader.swift
//  NASA
//
//  Created by Gavin Butler on 27-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class PhotoDownloader: Operation {
    //Download Rover image and assign it back to the Rover Photo instance
    
    var photo: RapidDownloadable
    
    init(photo: RapidDownloadable) {
        self.photo = photo
        super.init()
    }
    
    override func main() {
        
        //Check to see if the operation has been cancelled
        if self.isCancelled {
            return
        }
        
        //Download artwork associated with the rover photo.
        let url = photo.imageURL
        
        guard let imageData = try? Data(contentsOf: url) else { return }
        
        if self.isCancelled {
            return
        }
        
        if imageData.count > 0 {    ///Assume data is valid
            photo.image = UIImage(data: imageData)
            photo.imageDownloadState = .downloaded
        } else {
            photo.imageDownloadState = .failed
        }
    }
}
