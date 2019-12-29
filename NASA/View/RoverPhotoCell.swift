//
//  RoverPhotoCell.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class RoverPhotoCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: RoverPhotoCell.self)
    
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var roverNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func configure(with roverPhoto: RoverPhoto) {
        roverNameLabel.text = roverPhoto.rover.name + " : " + roverPhoto.camera.name + " : " + "(\(String(roverPhoto.id)))"
        roverNameLabel.adjustsFontSizeToFitWidth = true
        dateLabel.text = roverPhoto.earthDate
    }
}
