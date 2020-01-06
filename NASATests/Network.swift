//
//  Network.swift
//  NASATests
//
//  Created by Gavin Butler on 04-01-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import XCTest
@testable import NASA

class Network: XCTestCase {
    
    var client: NASAAPIClient!
    var photo: PhotoForTest!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        photo = PhotoForTest()
        client = NASAAPIClient()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        photo = nil
        client = nil
    }
    
    //Test Network request & timing for valid URL
    func testJSONFetch() {
        let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/opportunity/photos?api_key=4Ye02d6tWRNIZvP5a9RMOnFbePacsNy6ZfwIcW9l&earth_date=2015-11-5")!
        let request = URLRequest(url: url)
        let promise = expectation(description: "Success")
        
        client.fetchJSON(with: request, toType: RoverPhotos.self) { result in
            switch result {
            case .success:
                promise.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [promise], timeout: 2.0)
    }
    
    //Test that conformance to RapidDownloadable permits nil image only
    func testNilImage() {
        XCTAssertNil(photo.image)
        XCTAssertNotNil(photo.imageURL)
        XCTAssertNotNil(photo.imageDownloadState)
    }

}

class PhotoForTest: RapidDownloadable {
    var imageURL: URL = URL(string: "https://api.nasa.gov/")!
    var imageDownloadState: ImageDownloadState = .placeholder
    var image: UIImage?
}
