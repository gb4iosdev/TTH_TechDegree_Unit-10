//
//  PhotoDownloader.swift
//  NASA
//
//  Created by Gavin Butler on 27-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Handles downloading of the Images required for tableView Cells or collectionView Cells or similar.
class PhotoDownloader: AsyncOperation {
    
    //Of protocol type RapidDownloadable so that either a Mars Rover Photo or Astronomy Photo can be passed in.
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
        
        //Download artwork associated with the photo.
        let url = photo.imageURL
        
        Networker.request(url: url.absoluteString) { result in
            defer { self.state = .finished }
            if self.isCancelled {
                return
            }
            
            guard let imageData = try? result.get() else {
                self.photo.imageDownloadState = .failed
                return
            }
            self.photo.image = UIImage(data: imageData)
            self.state = .finished
            self.photo.imageDownloadState = .downloaded
        }
        
        if self.isCancelled {
            return
        }
    }
}
