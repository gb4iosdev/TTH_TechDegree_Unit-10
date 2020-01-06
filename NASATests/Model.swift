//
//  Model.swift
//  NASATests
//
//  Created by Gavin Butler on 04-01-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import XCTest
@testable import NASA

class Model: XCTestCase {
    
    var astronomyPhoto: AstronomyPhoto!
    var earthImage: EarthImage!
    var roverPhotos: RoverPhotos!
    
    let jsonExample = JSONExample()
    var astronomyPhotoJSONData: Data!
    var earthImageJSONData: Data!
    var roverPhotosJSONData: Data!
    
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        astronomyPhotoJSONData = jsonExample.astronomyPhoto
        earthImageJSONData = jsonExample.earthImage
        roverPhotosJSONData = jsonExample.roverPhotos
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        astronomyPhoto = nil
        astronomyPhotoJSONData = nil
        
        earthImage = nil
        earthImageJSONData = nil
        
        roverPhotos = nil
        roverPhotosJSONData = nil
    }

    func testAstronomyPhotoFromJSON() {
        astronomyPhoto = try! JSONDecoder().decode(AstronomyPhoto.self, from: astronomyPhotoJSONData)
        XCTAssertNotNil(astronomyPhoto, "Astronomy Photo could not be created from JSON")
        XCTAssertNil(astronomyPhoto.image, "Image Not Nil on creation")
        XCTAssertNil(astronomyPhoto.hdurl, "hdurl Not Nil on creation")
        XCTAssertNil(astronomyPhoto.copyright, "Copyright Not Nil on creation")
        
        //Can then assign:
        astronomyPhoto.image = UIImage()
        astronomyPhoto.hdurl = URL(string: "https://api.nasa.gov")
        astronomyPhoto.copyright = "Test string"
        XCTAssertNotNil(astronomyPhoto.image, "Image is Nil after attempted assignment")
        XCTAssertNotNil(astronomyPhoto.hdurl, "hdurl is Nil after attempted assignment")
        XCTAssertNotNil(astronomyPhoto.copyright, "Copyright is Nil after attempted assignment")
    }
    
    func testEarthImageFromJSON() {
        earthImage = try! JSONDecoder().decode(EarthImage.self, from: earthImageJSONData)
        XCTAssertNotNil(earthImage, "Earth Image could not be created from JSON")
        XCTAssertNil(earthImage.image, "Image Not Nil on creation")
        
        //Can then assign:
        earthImage.image = UIImage()
        XCTAssertNotNil(earthImage.image, "Image is Nil after attempted assignment")
    }
    
    func testRoverPhotosFromJSON() {
        roverPhotos = try! JSONDecoder().decode(RoverPhotos.self, from: roverPhotosJSONData)
        XCTAssertNotNil(roverPhotos, "Rover Photos could not be created from JSON")
        XCTAssertTrue(roverPhotos.photos.count == 3, "Incorrect number of Rover Photo entities downloaded")
        
        //Test the first photo assigned:
        let roverPhoto = roverPhotos!.photos[0]
        XCTAssertNil(roverPhoto.image, "Image Not Nil on creation")
        
        //Can then assign:
        roverPhoto.image = UIImage()
        XCTAssertNotNil(roverPhoto.image, "Image is Nil after attempted assignment")
        
        //Check correct downloadState
        XCTAssertTrue(roverPhoto.imageDownloadState == .placeholder, "ImageDownloadState default not correctly set")
    }

}

struct JSONExample {
    let astronomyPhoto: Data = """
    {
        "title" : "Test Title",
        "date" : "2020-01-01",
        "url" : "https://api.nasa.gov",
        "explanation" : "Test Explanation",
        "media_type" : "image"
    }
    """.data(using: .utf8)!
    
    let earthImage: Data = """
    {
        "cloud_score": 0.03926652301686606,
        "date" : "2014-02-04T03:30:01",
        "id" : "LC8_L1T_TOA/LC81270592014035LGN00",
        "url" : "https://earthengine.googleapis.com/api/thumb?thumbid=bc77b079c8ecd07cd668c576c22b83a4&token=83e8c4c4812bd83d0b37c60de93804c3",
    }
    """.data(using: .utf8)!
    
    let roverPhotos: Data = """
    {
      "photos": [
        {
            "id": 419982,
            "sol": 1073,
            "camera": {
                "id": 22,
                "name": "MAST",
                "rover_id": 5,
                "full_name": "Mast Camera"
            },
            "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/01073/mcam/1073MR0047190370600047C00_DXXX.jpg",
            "earth_date": "2015-08-13",
            "rover": {
                "id": 5,
                "name": "Curiosity",
                "landing_date": "2012-08-06",
                "launch_date": "2011-11-26",
                "status": "active",
                "max_sol": 2540,
                "max_date": "2019-09-28",
                "total_photos": 366206,
                "cameras": [
                    {
                        "name": "FHAZ",
                        "full_name": "Front Hazard Avoidance Camera"
                    },
                    {
                        "name": "NAVCAM",
                        "full_name": "Navigation Camera"
                    },
                    {
                        "name": "MAST",
                        "full_name": "Mast Camera"
                    },
                    {
                        "name": "CHEMCAM",
                        "full_name": "Chemistry and Camera Complex"
                    },
                    {
                        "name": "MAHLI",
                        "full_name": "Mars Hand Lens Imager"
                    },
                    {
                        "name": "MARDI",
                        "full_name": "Mars Descent Imager"
                    },
                    {
                        "name": "RHAZ",
                        "full_name": "Rear Hazard Avoidance Camera"
                    }
                ]
            }
        },
        {
            "id": 419983,
            "sol": 1073,
            "camera": {
                "id": 22,
                "name": "MAST",
                "rover_id": 5,
                "full_name": "Mast Camera"
            },
            "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/01073/mcam/1073ML0047190370206478C00_DXXX.jpg",
            "earth_date": "2015-08-13",
            "rover": {
                "id": 5,
                "name": "Curiosity",
                "landing_date": "2012-08-06",
                "launch_date": "2011-11-26",
                "status": "active",
                "max_sol": 2540,
                "max_date": "2019-09-28",
                "total_photos": 366206,
                "cameras": [
                    {
                        "name": "FHAZ",
                        "full_name": "Front Hazard Avoidance Camera"
                    },
                    {
                        "name": "NAVCAM",
                        "full_name": "Navigation Camera"
                    },
                    {
                        "name": "MAST",
                        "full_name": "Mast Camera"
                    },
                    {
                        "name": "CHEMCAM",
                        "full_name": "Chemistry and Camera Complex"
                    },
                    {
                        "name": "MAHLI",
                        "full_name": "Mars Hand Lens Imager"
                    },
                    {
                        "name": "MARDI",
                        "full_name": "Mars Descent Imager"
                    },
                    {
                        "name": "RHAZ",
                        "full_name": "Rear Hazard Avoidance Camera"
                    }
                ]
            }
        },
        {
            "id": 419984,
            "sol": 1073,
            "camera": {
                "id": 22,
                "name": "MAST",
                "rover_id": 5,
                "full_name": "Mast Camera"
            },
            "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/01073/mcam/1073MR0047190360600046C00_DXXX.jpg",
            "earth_date": "2015-08-13",
            "rover": {
                "id": 5,
                "name": "Curiosity",
                "landing_date": "2012-08-06",
                "launch_date": "2011-11-26",
                "status": "active",
                "max_sol": 2540,
                "max_date": "2019-09-28",
                "total_photos": 366206,
                "cameras": [
                    {
                        "name": "FHAZ",
                        "full_name": "Front Hazard Avoidance Camera"
                    },
                    {
                        "name": "NAVCAM",
                        "full_name": "Navigation Camera"
                    },
                    {
                        "name": "MAST",
                        "full_name": "Mast Camera"
                    },
                    {
                        "name": "CHEMCAM",
                        "full_name": "Chemistry and Camera Complex"
                    },
                    {
                        "name": "MAHLI",
                        "full_name": "Mars Hand Lens Imager"
                    },
                    {
                        "name": "MARDI",
                        "full_name": "Mars Descent Imager"
                    },
                    {
                        "name": "RHAZ",
                        "full_name": "Rear Hazard Avoidance Camera"
                    }
                ]
            }
        }
      ]
    }
    """.data(using: .utf8)!
}
