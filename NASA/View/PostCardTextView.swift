//
//  PostCardTextView.swift
//  NASA
//
//  Created by Gavin Butler on 29-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Subclassing UITextView to provide placeholder behaviour in the Rover Postcard customizable text view
class PostCardTextView: UITextView {

    private let placeholderText = "Enter postcard text here.\nDrag to move\nLong press to change text to black/white"

    //Set the placeholder text colour and actual text in the text view
    func setPlaceholder() {
        self.text = placeholderText
    }
    
    //Configure for editing
    func setForEditing(withIntialText text: String) {
        self.text = text
    }
    
    //Returns true if the existing text is all placeholder text
    var placeholderRemoved: Bool {
        return self.text! !=  placeholderText
    }
}
