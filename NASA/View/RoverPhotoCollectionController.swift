//
//  RoverPhotoCollectionController.swift
//  NASA
//
//  Created by Gavin Butler on 26-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//  Attribution:  www.raywenderlich.com
//  https://www.raywenderlich.com/9334-uicollectionview-tutorial-getting-started

import UIKit

class RoverPhotoCollectionController: UIViewController {

    //Networking variables
    let client = NASAAPIClient()
    let pendingOperations = PendingOperations()
    var pendingFetchURL: URL?   //Keeps track of the most recent URL requested through the UI
    
    //Collection View variables & constants:
    var roverPhotos: [RoverPhoto] = []
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 3
    var paddingSpace: CGFloat?
    var availableWidth: CGFloat?
    var widthPerItem: CGFloat?
    
    //Interface Builder Outlets:
    @IBOutlet weak var roverPhotoCollectionView: UICollectionView!
    @IBOutlet weak var roverSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cameraPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //UI Interaction Element defaults
    let pickerDefaultTextColour = UIColor.white
    let datePickerStartingDate = "2015-11-05"
    let segmentedControlColour = UIColor.white

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pre calculate collection view cell sizes
        setCollectionCellSizeParameters()
        
        //Date picker and segmented control settings
        configureUI()

        //Populate UI with initial data
        updateForRover()
        
    }
    
    //Rover selected
    @IBAction func roverSegmentedControlSelected(_ sender: UISegmentedControl) {
        
        updateForRover()
    }
    
    //Date selected
    @IBAction func dateSelected(_ sender: UIDatePicker) {
        
        fetchRoverPhotos()
    }
}


// MARK: - CollectionView DataSource & delegate methods:

extension RoverPhotoCollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //Datasource:
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.roverPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create and return a custom rover photo cell.
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverPhotoCell.reuseIdentifier, for: indexPath) as! RoverPhotoCell

        //Configure the cell with data from API
        let roverPhoto = roverPhotos[indexPath.row]
        photoCell.configure(with: roverPhoto)
        
        //Set the image
        if roverPhoto.imageDownloadState == .downloaded {   //If the image has already been downloaded, use that
            photoCell.roverImageView.image = roverPhoto.image
            photoCell.roverImageView.alpha = 1.0
        } else {    //Otherwise set the default image for immediate rendering <Might not need this code>
            photoCell.roverImageView.image = UIImage(named: "blank")!
        }
        
        //if image download state is placeholder, attempt a download:
        if  roverPhoto.imageDownloadState == .placeholder {
            downloadImage(roverPhoto, at: indexPath)
        }
        
        return photoCell
    }
    
    //Delegate:
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let width = self.widthPerItem {
            return CGSize(width: width, height: width)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

//MARK:- Pickerview delegation & data source
extension RoverPhotoCollectionController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Return the number of items in the static datasource for the associated rover
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let segmentedControlSelection = roverSegmentedControl.titleForSegment(at: roverSegmentedControl.selectedSegmentIndex), let chosenRover = Rover(rawValue: segmentedControlSelection.lowercased()) else { return 0 }
        
        return chosenRover.cameras.count
    }
    
    //Use viewForRow delegate method to return a view (UILabel) which allows for better control of the title formatting.
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        guard let segmentedControlSelection = roverSegmentedControl.titleForSegment(at: roverSegmentedControl.selectedSegmentIndex), let chosenRover = Rover(rawValue: segmentedControlSelection.lowercased()) else {
            let errorLabel = UILabel()
            errorLabel.text = "Error"
            return errorLabel
        }
        
        let pickerLabel = UILabel()
        let camera = chosenRover.cameras[row]
        let attributes = [NSAttributedString.Key.foregroundColor : pickerDefaultTextColour]
        let myTitle = NSAttributedString(string: camera.description, attributes: attributes)
        pickerLabel.attributedText = myTitle
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.textAlignment = .center
       return pickerLabel
    }
    
    //Use the selected row as input for the endpoint.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        fetchRoverPhotos()
    }
    
}


//MARK:- Helper Methods:
extension RoverPhotoCollectionController {
    
    //Precalculate cell dimensions to save time in sizeForItemAt
    func setCollectionCellSizeParameters() {
        paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        availableWidth = view.frame.width - paddingSpace!
        widthPerItem = availableWidth! / itemsPerRow
    }
    
    func configureUI() {
        //Configure Date Picker parameters
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.maximumDate = Date(timeIntervalSinceNow: 0.0)
        datePicker.date = Date.fromEarthDate(datePickerStartingDate)!
        datePicker.setValue(false, forKey: "highlightsToday")
     
        //Configure Segmented Control
        roverSegmentedControl.backgroundColor = UIColor.clear
        let attributes = [NSAttributedString.Key.foregroundColor : segmentedControlColour]
        roverSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
    }

    //Update the UI controls dependent on the Rover segmented control, and fetch
    func updateForRover()  {
        //Set minimum date for date picker
        guard let segmentedControlSelection = roverSegmentedControl.titleForSegment(at: roverSegmentedControl.selectedSegmentIndex), let rover = Rover(rawValue: segmentedControlSelection.lowercased()) else { return }
        datePicker.minimumDate = rover.landingDate
        
        //Reload the cameras
        cameraPicker.reloadAllComponents()
        
        //Fetch the photos
        fetchRoverPhotos()
    }

    //Download the image for the collection view cell
    func downloadImage (_ roverPhoto: RoverPhoto, at indexPath: IndexPath) {
        
        //Don’t do anything if this download is already in progress.
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //Otherwise instantiate a PhotoDownloader operation, set it’s completion handler, register the operation in the tracker dictionary (downloadsInProgress), and add it to the queue for execution.
        let downloader = PhotoDownloader(photo: roverPhoto)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.roverPhotoCollectionView.reloadItems(at: [indexPath])
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}


//MARK: - Networking
extension RoverPhotoCollectionController {
    
    func fetchRoverPhotos() {
        
        //Construct the endpoint from the UI:
        guard let segmentedControlSelection = roverSegmentedControl.titleForSegment(at: roverSegmentedControl.selectedSegmentIndex), let rover = Rover(rawValue: segmentedControlSelection.lowercased()) else { return }
        
        let camera = rover.cameras[cameraPicker.selectedRow(inComponent: 0)]
        
        let date = datePicker.date
        
        let endpoint =  NASAEndpoint.marsRoverPhotos(rover: rover, camera: camera, date: date)
        
        //Save this as the current pending Fetch:
        self.pendingFetchURL = endpoint.request.url
        
        //Execute the fetch
        client.fetchJSON(with: endpoint.request, toType: RoverPhotos.self) { [weak self] result in
            switch result {
            case .success(let results):
                //Add results to dataSource:
                let photos = results.photos as [RoverPhoto]
                
                if endpoint.request.url == self?.pendingFetchURL {             //Otherwise do nothing as the UI has changed and prompted another fetch
                    self?.roverPhotos = photos
                    DispatchQueue.main.async {
                        self?.roverPhotoCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error is: \(String(describing: error))")
            }
        }
    }
}

//MARK: - Segues
extension RoverPhotoCollectionController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //check that the sender has a photo:
        guard let photoCell = sender as? RoverPhotoCell, let photoIndex = roverPhotoCollectionView.indexPathsForSelectedItems?.first?.row, roverPhotos[photoIndex].imageDownloadState == .downloaded else {
            print("Error:  No Photo image yet for selected Cell")
            return
        }
        
        //check that we have the right segue
        guard segue.identifier == "PostCard", let postCardController = segue.destination as? RoverPostCardController else {
            print("Error:  Attempted segue not registered")
            return
        }
        
        //Dependency inject the rover image
        postCardController.roverImage = photoCell.roverImageView.image
        
    }
}
