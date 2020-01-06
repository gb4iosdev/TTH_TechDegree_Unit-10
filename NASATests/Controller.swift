//
//  Controller.swift
//  NASATests
//
//  Created by Gavin Butler on 04-01-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import XCTest
@testable import NASA

class Controller: XCTestCase {
    
    var mapController: MapController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mapController = MapController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mapController = nil
    }

    //Map view should always be instantiated without any filtered places initially:
    func testFilteredPlaces() {
        XCTAssert(mapController.filteredPlaces.count == 0, "Filtered Places should not be populated on Map View Instantiation")
    }
}
