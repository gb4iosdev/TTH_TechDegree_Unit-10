//
//  EndpointTest.swift
//  NASATests
//
//  Created by Gavin Butler on 04-01-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import XCTest
@testable import NASA

class EndpointTest: XCTestCase {
    
    var endpoint: NASAEndpoint!
    let apiKey = "4Ye02d6tWRNIZvP5a9RMOnFbePacsNy6ZfwIcW9l"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Rover Endpoint
    func testRoverEndpoint() {
        //Given:
        let rover = Rover.curiosity
        let camera = Camera.chemcam
        let date = Date.init(timeIntervalSinceNow: 0.0)
        let dateAsEarthDate = date.asEarthDate()
        
        //When:
        endpoint = NASAEndpoint.marsRoverPhotos(rover: rover, camera: camera, date: date)
        
        //Assert:
        let expectedURLString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?camera=chemcam&earth_date=" + dateAsEarthDate + "&api_key=" + apiKey
        let expectedURL = URL(string: expectedURLString)
        XCTAssertEqual(endpoint.request.url, expectedURL, "Incorrect URL returned for rover")
    }

    //Earth Image Endpoint
    func testEarthImageEndpoint() {
        //Given:
        let latitude: Double = 45.0
        let longitude: Double = -75.9
        
        //When:
        endpoint = NASAEndpoint.earthImage(latitude: latitude, longitude: longitude)
        
        //Assert:
        let expectedURLString = "https://api.nasa.gov/planetary/earth/imagery/?lat=45.0&lon=-75.9&cloud_score=true" + "&api_key=" + apiKey
        let expectedURL = URL(string: expectedURLString)
        XCTAssertEqual(endpoint.request.url, expectedURL, "Incorrect URL returned for earth image")
    }
    
    //Astronomy Image Endpoint
    func testAstronomyImageEndpoint() {
        //Given:
        let date = Date.init(timeIntervalSinceNow: 0.0)
        let dateAsEarthDate = date.asEarthDate()
        
        //When:
        endpoint = NASAEndpoint.astronomyImage(date: date)
        
        //Assert:
        let expectedURLString = "https://api.nasa.gov/planetary/apod?date=" + dateAsEarthDate + "&api_key=" + apiKey
        let expectedURL = URL(string: expectedURLString)
        XCTAssertEqual(endpoint.request.url, expectedURL, "Incorrect URL returned for astronomy image")
    }
    
}
