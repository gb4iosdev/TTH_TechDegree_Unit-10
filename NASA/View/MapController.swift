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
    var earthImage: EarthImage?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageDataLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapCentre = CLLocationCoordinate2D(latitude: 45.25826, longitude: -75.933997)
        
        mapView.adjust(centreTo: mapCentre, span: 1_000)
        
        fetchEarthImageryData(at: mapCentre)
    }
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
            print("Got this far")
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
