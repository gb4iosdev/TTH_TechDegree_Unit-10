//
//  AstronomyPhotoCollectionController.swift
//  NASA
//
//  Created by Gavin Butler on 30-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Controls the fetching and display of NASA ‘Astronomy Picture Of the Day’ (APOD) API photographs and related information
class AstronomyPhotoCollectionController: UIViewController {

    //Data Source
    var astronomyPhotos: [AstronomyPhoto] = []
    var photoDates: [Date] = []
    let numberOfPhotos = 30
    
    //Network
    let client = NASAAPIClient()
    let pendingOperations = PendingOperations()
    
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
        
        configureUI()

        //Set up the array of dates from today and going back ‘numberOfPhotos’ days
        for i in 0..<numberOfPhotos {
            let offset: Double = -Double(i) * 24*60*60
            photoDates.append(Date(timeIntervalSinceNow: offset))
        }
        
        //Execute the API fetch
        fetchAstronomyPhotos()
        
    }
}

//MARK: - Collection View Datasource & Delegate methods
extension AstronomyPhotoCollectionController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Datasource:
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return astronomyPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create a custom astronomy photo cell.
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: AstronomyPhotoCell.reuseIdentifier, for: indexPath) as! AstronomyPhotoCell

        //Configure the cell with the astronomyPhoto data
        let astronomyPhoto = astronomyPhotos[indexPath.row]
        photoCell.configure(with: astronomyPhoto)
        
        //Set the image if already downloaded, or blank image otherwise
        if astronomyPhoto.imageDownloadState == .downloaded {
            photoCell.astronomyImageView.image = astronomyPhoto.image
            photoCell.astronomyImageView.alpha = 1.0
        } else {    //Otherwise set the default image for immediate rendering
            photoCell.astronomyImageView.image = UIImage(named: "blank")!
        }
        
        //if image download state is placeholder, attempt a download:
        if  astronomyPhoto.imageDownloadState == .placeholder {
            downloadImage(astronomyPhoto, at: indexPath)
        }
        
        return photoCell
    }
    
    //If a collection view item is chosen, set the main image labels and set the main image with the fetched HD image (if url is available), otherwise the standard definition image.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenPhoto = astronomyPhotos[indexPath.row]
        featurePhotoTitleLabel.text = chosenPhoto.title
        featurePhotoTitleLabel.isHidden = false
        featurePhotoDetailLabel.text = chosenPhoto.date
        featurePhotoDetailLabel.isHidden = false
        if let hdURL = chosenPhoto.hdurl {
            fetchHDAstronomyImage(at: hdURL)
        } else if let standardResolutionImage = chosenPhoto.image {
            imageView.image = standardResolutionImage
        } else {
            imageView.image = UIImage(named: "blank")   //Should never execute
        }
    }
}

//MARK:- Helper Methods:
extension AstronomyPhotoCollectionController {
    
    func configureUI() {
        //Set the layout for the collection view controller – 2 columns of photos, no spacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.itemSize = CGSize(width: screenSize.width/itemsPerRow, height: screenSize.height/(itemsPerRow*2))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        astronomyPhotoCollectionView.collectionViewLayout = layout
    }
    
    //Starts the asynchronous image download for Collection View cells (if not already started).
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
            
            //On completion, reload the collectionview cell for the selected item only to display the image.  Remove from the downloads tracker dictionary.
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.astronomyPhotoCollectionView.reloadItems(at: [indexPath])
            }
        }
        
        // Register in the downloads tracker dictionary and add the operation to the queue
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}

//MARK: - Networking
extension AstronomyPhotoCollectionController {
    
    func fetchAstronomyPhotos() {
        
        var fetchCount = 0
        
        for photoDate in photoDates {
            //Construct the endpoint:
            let endpoint = NASAEndpoint.astronomyImage(date: photoDate)
            
            //Execute the fetch
            client.fetchJSON(with: endpoint.request, toType: AstronomyPhoto.self) { [weak self] result in
                //Increment the fetch number:
                fetchCount += 1
                switch result {
                case .success(let result):
                    //Add results to dataSource:
                    let astronomyImageData = result as AstronomyPhoto
                    if astronomyImageData.mediaType == "image" {
                        self?.astronomyPhotos.append(astronomyImageData)
                    }
                    
                case .failure(let error):
                    print("Error is: \(String(describing: error)) for url: \(endpoint.request.url)")
                }
                //If they're all done, sort the astronomyPhotos array and reload the Collection View, to kick off photo fetching
                if fetchCount == self?.photoDates.count {
                    self?.astronomyPhotos.sort {
                        Date.fromEarthDate($0.date)! > Date.fromEarthDate($1.date)!
                    }

                    DispatchQueue.main.async {
                        self?.astronomyPhotoCollectionView.reloadData()
                    }
                }
            }
        }
    }

    //Fetch the high resolution astronomy image (if available)
    func fetchHDAstronomyImage(at url: URL) {
        
        Networker.request(url: url.absoluteString) { result in
            do {
                let imageData = try result.get()
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
