//
//  View.swift
//  NASATests
//
//  Created by Gavin Butler on 05-01-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import XCTest
@testable import NASA

class View: XCTestCase {
    
    var postCardTextView: PostCardTextView!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        postCardTextView = PostCardTextView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        postCardTextView = nil
    }
    
    //Tests PostCardTextView functions
    func testPlaceHolderChanges() {
        //Check placeholder text initialized:
        XCTAssertEqual(postCardTextView.placeholderText, "Enter postcard text here.\nDrag to move\nLong press to change text to black/white", "PostCard text view placeholder text not initialized properly")
        
        //Check that the text is set to this when setPlaceholder is called:
        postCardTextView.setPlaceholder()
        XCTAssertEqual(postCardTextView.text, "Enter postcard text here.\nDrag to move\nLong press to change text to black/white", "PostCard text view text not set properly")
        
        //Modify the text and check that the text is replaced.
        postCardTextView.setForEditing(withIntialText: "Test")
        XCTAssertEqual(postCardTextView.text, "Test", "PostCard text view text not modified properly")
        XCTAssertTrue(postCardTextView.placeholderRemoved, "Placeholder text not recognized as removed")
        
    }

}
