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

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //create the endpoint
        let endpoint = NASAEndpoint.astronomyImage(date: nil)
        
        fetchAstronomyImageData(at: endpoint)
    }
}

//MARK: - Networking
extension AstronomyPhotoCollectionController {
    
    func fetchAstronomyImageData(at endpoint: NASAEndpoint) {
        
        print("Endpoint is: \(endpoint.request.url)")
        
        //Execute the fetch
        client.fetchJSON(with: endpoint.request, toType: AstronomyImage.self) { [weak self] result in
            switch result {
            case .success(let result):
                //Add results to dataSource:
                let astronomyImageData = result as AstronomyImage
                print("Astronomy Image title is: \(astronomyImageData.title)")
                print("Astronomy Image date is: \(astronomyImageData.date)")
                print("Astronomy Image url is: \(astronomyImageData.url)")
                let urls:[URL] = [astronomyImageData.url, astronomyImageData.hdurl]
                self?.fetchAstronomyImage(with: astronomyImageData.url)
//                DispatchQueue.main.async {
//                    self?.configureImageDataLabel()
//                }
            case .failure(let error):
                print("Error is: \(String(describing: error))")
            }
        }
    }

    func fetchAstronomyImage(with urls: [URL]) {
    
        guard let imageData = try? Data(contentsOf: url) else { return }
        
        if imageData.count > 0 {    ///Assume data is valid
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
}
