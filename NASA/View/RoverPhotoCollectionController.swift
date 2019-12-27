//
//  RoverPhotoCollectionController.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class RoverPhotoCollectionController: UIViewController {

    let client = NASAAPIClient()
    var roverPhotos: [RoverPhoto] = []
    
    @IBOutlet weak var roverPhotoCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roverPhotoCollectionView.dataSource = self
        
        let endpoint: NASAEndpoint = .marsRoverPhotos(rover: .curiosity, camera: .chemcam, date: Date(timeIntervalSince1970: 450000))
        print(endpoint.request.url)
        fetchRoverPhotos(at: endpoint)
        
    }
}

// MARK: - CollectionViewDataSource methods:

extension RoverPhotoCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.roverPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Return a custom photo cell which is defined in IB and contains a simple reuseID property and IBOutlet to an imageView to display the image.
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverPhotoCell.reuseIdentifier, for: indexPath) as! RoverPhotoCell
        
//        if let images = self.images {
//            photoCell.photoImageView.image = images[indexPath.row]
//        }
        
        return photoCell
    }
    
    
}

//MARK: - Networking
extension RoverPhotoCollectionController {
    
    func fetchRoverPhotos(at endpoint: Endpoint) {
        client.fetchJSON(with: endpoint.request, toType: RoverPhotos.self) { [weak self] result in
            switch result {
            case .success(let results):
                //Add results to dataSource:
                let photos = results.photos as [RoverPhoto]
                self?.roverPhotos = photos
                print("Success")
                print("Rover photos are:")
                for photo in photos {
                    print(photo.id)
                }
                DispatchQueue.main.async {
                    self?.roverPhotoCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error is: \(String(describing: error))")
            }
        }
    }
}
