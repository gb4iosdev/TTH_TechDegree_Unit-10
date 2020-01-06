//
//  ViewController.swift
//  NASA
//
//  Created by Gavin Butler on 25-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var roverTitleLabel: UILabel!
    @IBOutlet weak var roverSubTitleLabel: UILabel!
    
    @IBOutlet weak var eyeInTheSkyLabel: UILabel!
    
    @IBOutlet weak var astronomyPhotosLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aileronsLargeFont = UIFont(name: "Ailerons-Regular", size: 35)
        let aileronsSmallFont = UIFont(name: "Ailerons-Regular", size: 24)
        
        roverTitleLabel.font = aileronsLargeFont
        roverSubTitleLabel.font = aileronsSmallFont
        
        eyeInTheSkyLabel.font = aileronsLargeFont
        
        astronomyPhotosLabel.font = aileronsLargeFont
    }
}
