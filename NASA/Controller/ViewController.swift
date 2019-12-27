//
//  ViewController.swift
//  NASA
//
//  Created by Gavin Butler on 25-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let client = NASAAPIClient()
    var roverPhotos: [RoverPhoto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
