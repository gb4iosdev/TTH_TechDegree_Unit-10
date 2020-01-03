//
//  AstronomyPhotoCollectionController.swift
//  NASA
//
//  Created by Gavin Butler on 30-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class AstronomyPhotoCollectionController: UIViewController {
    
    let client = NASAAPIClient()
    var astronomyPhotos: [AstronomyPhoto] = []
    var photoDates: [Date] = []
    let pendingOperations = PendingOperations()
    
    let numberOfPhotos = 20
    
    //Collection View variables & constants:
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let itemsPerRow: CGFloat = 2
    let screenSize = UIScreen.main.bounds

    //Interface Builder Outlets:
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var astronomyPhotoCollectionView: UICollectionView!
    @IBOutlet weak var featurePhotoTitleLabel: UILabel!
    @IBOutlet weak var featurePhotoDetailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = sectionInsets
            layout.itemSize = CGSize(width: screenSize.width/2, height: screenSize.height/4)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            astronomyPhotoCollectionView.collectionViewLayout = layout

        //Set up the array of dates:
        for i in 0..<numberOfPhotos {
            let offset: Double = -Double(i) * 24*60*60
            photoDates.append(Date(timeIntervalSinceNow: offset))
        }
        print(photoDates)
        //create the endpoint
        //let endpoint = NASAEndpoint.astronomyImage(date: nil)
        
        fetchAstronomyPhotos()
        
    }
}

//MARK: - Networking
extension AstronomyPhotoCollectionController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Datasource:
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.roverPhotos.count
        return astronomyPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Return a custom astronomy photo cell.
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: AstronomyPhotoCell.reuseIdentifier, for: indexPath) as! AstronomyPhotoCell

        let astronomyPhoto = astronomyPhotos[indexPath.row]
        photoCell.configure(with: astronomyPhoto)
        
        if astronomyPhoto.imageDownloadState == .downloaded {   //If the image has already been downloaded, use that
            photoCell.astronomyImageView.image = astronomyPhoto.image
            photoCell.astronomyImageView.alpha = 1.0
        } else {    //Otherwise set the default image for immediate rendering <Might not need this code>
            photoCell.astronomyImageView.image = UIImage(named: "blank")!
        }
        
        //if image download state is placeholder, attempt a download:
        if  astronomyPhoto.imageDownloadState == .placeholder {
            downloadImage(astronomyPhoto, at: indexPath)
        }
        
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(astronomyPhotos[indexPath.row].title)")
        let chosenPhoto = astronomyPhotos[indexPath.row]
        featurePhotoTitleLabel.text = chosenPhoto.title
        featurePhotoDetailLabel.text = chosenPhoto.date
        if let hdURL = chosenPhoto.hdurl {
            fetchHDAstronomyImage(at: hdURL)
        } else if let standardResImage = chosenPhoto.image {
            imageView.image = standardResImage
        } else {
            imageView.image = UIImage(named: "blank")   //Should never execute
        }
    }
}

//MARK:- Helper Methods:
extension AstronomyPhotoCollectionController {
    
    func downloadImage (_ astronomyPhoto: AstronomyPhoto, at indexPath: IndexPath) {
        
        //Don’t do anything if this download is already in progress.
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //Otherwise instantiate a PhotoDownloader operation, set it’s completion handler, register the operation in the tracker dictionary (downloadsInProgress), and add it to the queue for execution.
        let downloader = PhotoDownloader(photo: astronomyPhoto)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.astronomyPhotoCollectionView.reloadItems(at: [indexPath])
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}

//MARK: - Networking
extension AstronomyPhotoCollectionController {
    
    func fetchAstronomyPhotos() {
        
        var fetchCount = 0
        
        for i in 0..<numberOfPhotos {
            //Construct the endpoint:
            let endpoint = NASAEndpoint.astronomyImage(date: photoDates[i])
            
            //Execute the fetch
            client.fetchJSON(with: endpoint.request, toType: AstronomyPhoto.self) { [weak self] result in
                //Increment the fetch number:
                fetchCount += 1
                switch result {
                case .success(let result):
                    //Add results to dataSource:
                    let astronomyImageData = result as AstronomyPhoto
                    print("Astronomy Image title is: \(astronomyImageData.title)")
                    print("Astronomy Image date is: \(astronomyImageData.date)")
                    print("Endpoint is: \(endpoint.request.url)")
                    if astronomyImageData.mediaType == "image" {
                        self?.astronomyPhotos.append(astronomyImageData)
                    }
                    //let urls:[URL] = [astronomyImageData.imageURL, astronomyImageData.hdurl]
                    //self?.fetchAstronomyImage(with: astronomyImageData.imageURL)
    //                DispatchQueue.main.async {
    //                    self?.configureImageDataLabel()
    //                }
                    
                case .failure(let error):
                    print("Error is: \(String(describing: error)) for url: \(endpoint.request.url)")
                }
                //Refresh Collection View if they're all done:
                if fetchCount == self?.numberOfPhotos {
                    DispatchQueue.main.async {
                        print("Got to here")
                        self?.astronomyPhotoCollectionView.reloadData()
                    }
                }
            }
        }
    }

    func fetchHDAstronomyImage(at url: URL) {
    
        guard let imageData = try? Data(contentsOf: url) else { return }
        
        if imageData.count > 0 {    ///Assume data is valid
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
}
