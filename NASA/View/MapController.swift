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
    
    let client = NASAAPIClient()
    let resultsController = UITableViewController(style: .plain)
    var earthImage: EarthImage?
    
    //Search/map related variables & constants
    let searchRequest = MKLocalSearch.Request()
    let mapSpan = 1_400.0
    let defaultLocation = CLLocationCoordinate2D(latitude: 45.4083, longitude: -75.7187)
    var filteredPlaces: [MKMapItem] = []    //Datasource for search
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageDataLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.adjust(centreTo: defaultLocation, span: mapSpan)
        mapView.addAnnotation(at: defaultLocation, title: "Ottawa", subTitle: "Ottawa City Centre")
        
        fetchEarthImageryData(at: defaultLocation)
        
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal
        self.definesPresentationContext = true
        searchController.searchBar.placeholder = "Enter place/location to find"
        navigationItem.searchController = searchController
        
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        searchController.searchBar.delegate = self
        resultsController.tableView.register(SearchResultCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        mapView.removeBlurrEffect()
//        imageView.removeBlurrEffect()
//    }
}



//MARK: - Networking
extension MapController {
    
    func fetchEarthImageryData(at coordinate: CLLocationCoordinate2D) {
        
        //Construct the endpoint:
        
        let endpoint =  NASAEndpoint.earthImage(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        print("Endpoint is: \(endpoint.request.url)")
        
        //Execute the fetch
        client.fetchJSON(with: endpoint.request, toType: EarthImage.self) { [weak self] result in
            switch result {
            case .success(let result):
                //Add results to dataSource:
                self?.earthImage = result as EarthImage
                print("EarthImage ID is: \(self?.earthImage?.id) and URL is: \(self?.earthImage?.url)")
                if let url = self?.earthImage?.url {
                    self?.fetchEarthImage(with: url)
                }
                DispatchQueue.main.async {
                    self?.configureImageDataLabel()
                }
            case .failure(let error):
                print("Error is: \(String(describing: error))")
            }
        }
    }
    
    func fetchEarthImage(with url: URL) {
        
        guard let imageData = try? Data(contentsOf: url) else { return }
        
        if imageData.count > 0, let earthImage = self.earthImage {    ///Assume data is valid
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
        
        
    }
    
}

//MARK: - Helper Methods
extension MapController {
    func configureImageDataLabel() {
        if let earthImageData = self.earthImage {
            var labelString = "ID: \(earthImageData.id)  "
            labelString.append("Date: \(earthImageData.imageDate.prefix(10))  ")
            labelString.append("CloudScore: \(earthImageData.cloudScore.asPercent())")
            print("labelString")
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
        } else {
            mapView.addBlurrEffect()
            imageView.addBlurrEffect()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar cancelled")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        let mapKitItem = filteredPlaces[indexPath.row]
        cell.textLabel?.text = mapKitItem.name
        cell.detailTextLabel?.text = mapKitItem.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
