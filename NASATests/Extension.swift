//
//  Extension.swift
//  NASATests
//
//  Created by Gavin Butler on 04-01-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import XCTest
import MapKit
@testable import NASA

class Extension: XCTestCase {
    
    var mapView: MockMKMapView!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mapView = MockMKMapView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mapView = nil
    }

    //Test that the fromEarthDate function on the Date type returns nil if date not in expected ""yyyy-MM-dd" format
    func testDateFormat() {
        let dateInCorrectFormat = "2011-05-01"
        let dateInIncorrectFormat = "20110501"
        
        XCTAssertNotNil(Date.fromEarthDate(dateInCorrectFormat), "Valid Date string returns Nil!")
        XCTAssertNil(Date.fromEarthDate(dateInIncorrectFormat), "Invalid Date string returns a Date!")
    }
    
    //Test that MKMapView extension 'adjust' function calls setRegion overloaded method
    func testCallToSetRegion() {
        let coordinate = CLLocationCoordinate2D(latitude: 45.0, longitude: -79.5)
        let span: Double = 1000.0
        mapView.adjust(centreTo: coordinate, span: span)
        
        XCTAssertTrue(mapView.didCallSetRegionOverload)
    }
    
    //Mocking a class to test flow of extension functions.
    class MockMKMapView: MKMapView {
        
        var didCallSetRegionOverload = false
        
        override func setRegion(around coordinate: CLLocationCoordinate2D, withSpan span: Double) {
            didCallSetRegionOverload = true
        }
    }
}
