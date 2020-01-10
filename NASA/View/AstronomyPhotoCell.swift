//
//  AstronomyPhotoCell.swift
//  NASA
//
//  Created by Gavin Butler on 31-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Custom cell for AstronomyPhoto CollectionView
class AstronomyPhotoCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: AstronomyPhotoCell.self)
    
    
    @IBOutlet weak var astronomyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    //Configure the cell’s labels from an AstronomyPhoto object.
    func configure(with astronomyPhoto: AstronomyPhoto) {
        titleLabel.text = astronomyPhoto.title
        titleLabel.adjustsFontSizeToFitWidth = true
        
        var suffix = ""
        
        if let copyright = astronomyPhoto.copyright {
            suffix = " : \(copyright)"
        }
        detailLabel.text = astronomyPhoto.date + suffix
        detailLabel.adjustsFontSizeToFitWidth = true
    }
    
}
