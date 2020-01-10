//
//  MapController.swift
//  NASA
//
//  Created by Gavin Butler on 29-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    //Network variables
    let client = NASAAPIClient()
    var earthImage: EarthImage?
    
    //Search & map related variables & constants
    let searchRequest = MKLocalSearch.Request()
    let mapSpan = 1_400.0
    var filteredPlaces: [MKMapItem] = []    //Datasource for search
    
    //Search Results
    let resultsController = UITableViewController(style: .plain)
    let resultsControllerDefaultCellIdentifier = "Default Cell"
    
    //IB Outlet variables
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageDataLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        configureResultsController()
    }
}



//MARK: - Networking
extension MapController {
    
    func fetchEarthImageryData(at coordinate: CLLocationCoordinate2D) {
        
        //Construct the endpoint:
        
        let endpoint =  NASAEndpoint.earthImage(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        //Execute the fetch
        client.fetchJSON(with: endpoint.request, toType: EarthImage.self) { [weak self] result in
            switch result {
            case .success(let result):
                //Add results to dataSource:
                self?.earthImage = result as EarthImage
                //If the earth image data comes with a url asynchronously fetch this to retrieve the image
                if let url = self?.earthImage?.url {
                    self?.fetchEarthImage(with: url)
                }
                //Populate the labels from the data while the image is fetching.
                DispatchQueue.main.async {
                    self?.configureImageDataLabel()
                }
            case .failure(let error):
                print("Error is: \(String(describing: error))")
            }
        }
    }
    
    func fetchEarthImage(with url: URL) {
        
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

//MARK: - Helper Methods
extension MapController {
    
    //Set searchController parameters and assign to the navigation bar
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal
        self.definesPresentationContext = true
        searchController.searchBar.placeholder = "Enter place/location to find"
        searchController.searchBar.barStyle = UIBarStyle.black
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    //Set resultsController delegate, datasource and register cell.
    func configureResultsController() {
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        resultsController.tableView.register(SearchResultCell.self, forCellReuseIdentifier: resultsControllerDefaultCellIdentifier)
    }

    //Set the Label displaying image information if set
    func configureImageDataLabel() {
        if let earthImageData = self.earthImage {
            var labelString = "ID: \(earthImageData.id)  "
            labelString.append("Date: \(earthImageData.imageDate.prefix(10))  ")
            labelString.append("CloudScore: \(earthImageData.cloudScore.asPercent())")
            imageDataLabel.adjustsFontSizeToFitWidth = true
            imageDataLabel.text = labelString
        }
    }
}

//SearchController delegate methods:
extension MapController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //If there is text, use it as the filter
        if !searchController.searchBar.text!.isEmpty {
            searchRequest.naturalLanguageQuery = searchController.searchBar.text!
            searchRequest.region = mapView.region
            
            let search = MKLocalSearch(request: searchRequest)
            
            search.start { response, error in
                if let response = response {
                    //If we have a valid response, extract the MKMapItems, and execute tableview reload on main queue.
                    self.filteredPlaces = response.mapItems
                    DispatchQueue.main.async {
                        self.resultsController.tableView.reloadData()
                    }
                }
            }
        } else {        //Remove annotations and blur the views to put the focus back on the search bar
            mapView.addBlurrEffect()
            mapView.removeAllAnnotations()
            imageView.addBlurrEffect()
        }
    }
    
    //Restore image clarity if search cancelled
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mapView.removeBlurrEffect()
        imageView.removeBlurrEffect()
    }
    
}

//ResultsController datasource and delegate methods:
extension MapController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaces.count
    }
    
        //Extract the result information from the mapKit item and apply to the cell labels.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: resultsControllerDefaultCellIdentifier) else { return UITableViewCell() }
        let mapKitItem = filteredPlaces[indexPath.row]
        cell.textLabel?.text = mapKitItem.name
        cell.detailTextLabel?.text = mapKitItem.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Dismiss the results controller, update the map view and start the image fetch based on the chosen location
        resultsController.dismiss(animated: true, completion: {
            let resultsSelection = self.filteredPlaces[indexPath.row]
            if let resultsCoordinate = resultsSelection.placemark.location?.coordinate {
                self.imageView.removeBlurrEffect()
                self.fetchEarthImageryData(at: resultsCoordinate)
                self.mapView.removeBlurrEffect()
                self.mapView.adjust(centreTo: resultsCoordinate, span: self.mapSpan)
                self.mapView.addAnnotation(at: resultsCoordinate, title: resultsSelection.name, subTitle: resultsSelection.address)
            }
        })
    }
    
    
}
