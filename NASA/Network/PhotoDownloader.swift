//
//  PhotoDownloader.swift
//  NASA
//
//  Created by Gavin Butler on 27-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Handles downloading of the Images required for tableView Cells or collectionView Cells or similar.
class PhotoDownloader: Operation {
    
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
        
        /*Networker.request(url: url.absoluteString) { result in
            if self.isCancelled {
                return
            }
            do {
                let imageData = try result.get()
                self.photo.image = UIImage(data: imageData)
                self.photo.imageDownloadState = .downloaded
                
            } catch {
                self.photo.imageDownloadState = .failed
            }
        }*/
        
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
