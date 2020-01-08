//
//  RoverPostCardController.swift
//  NASA
//
//  Created by Gavin Butler on 28-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import MessageUI

//Controls the display of the chosen rover photo, application of text to the photo and preparation for emailing by user
class RoverPostCardController: UIViewController {
    
    //Interface Builder Outlets:
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var textView: PostCardTextView!
    
    //Main Image used, passed in from RoverPhotoCollectionController
    var roverImage: UIImage?
    
    //Email constants:
    let toRecipient = "gavin.butler01@bigpond.com"
    let subject = "Greetings from Mars"
    let defaultBody = "Greetings from Mars…"

    override func viewDidLoad() {
        super.viewDidLoad()

        //If image has been successfully injected, display and set placeholder editing text
        if let image = roverImage {
            roverImageView.image = image
            textView.setPlaceholder()
        }
        
        //Set the UITextView delegate and returnKey type.
        textView.delegate = self
        textView.returnKeyType = .done
    }
    
    //If user elects to send, configure the mail controller and present.  User is responsible for sending or cancelling.
    @IBAction func sendPressed(_ sender: UIBarButtonItem) {
        
        let mailComposer = configuredMailController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposer, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    //Detect pan gesture on Text view and move accordingly.
    @IBAction func textViewPanning(_ sender: UIPanGestureRecognizer) {
        guard let recognizerView = sender.view else { return }

        let translation = sender.translation(in: view)
        recognizerView.center.x += translation.x
        recognizerView.center.y += translation.y
        sender.setTranslation(.zero, in: view)
    }
    
    //Change text from white to black or vice versa to allow for simple contrast against image.
    @IBAction func textViewLongPressed(_ sender: UILongPressGestureRecognizer) {
        //Don't execute when fingers lifted
        guard sender.state != .ended else { return }
        
        if textView.textColor == .white {
            textView.textColor = .black
        } else {
            textView.textColor = .white
        }
    }
}

//MARK: - Mail View Controller Delegate methods
extension RoverPostCardController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //Configure the mail controller
    func configuredMailController() -> MFMailComposeViewController {
        //Set basic email parameters
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([toRecipient])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(defaultBody, isHTML: true)

        //Capture entire screen (image and text) and Add as attachment
        if let _ = roverImage{
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let image = renderer.image { ctx in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
            let imageData = image.pngData()!
            mailComposer.addAttachmentData(imageData, mimeType: "image/png", fileName: "roverImage.png")
        }
        
        return mailComposer
    }
    
    //Error alert shown if mail composer can’t send mail
    func showMailError() {
        let mailErrorAlert = UIAlertController(title: "Mail Send Error", message: "Could not send email.  Note not sendable from Simulator", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        mailErrorAlert.addAction(action)
        self.present(mailErrorAlert, animated: true, completion: nil)
    }
}

//  MARK: - UITextView Delegate methods to support placeholder text behaviour
extension RoverPostCardController: UITextViewDelegate {
    
    //Blank text view to remove placeholder/instructional text when initially selected
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textView = textView as? PostCardTextView, !textView.placeholderRemoved {
            textView.setForEditing(withIntialText: "")
        }
    }
    
    //Resign keyboard if enter selected
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    //Reinstate the placeholder text if all user text is removed.
    func textViewDidEndEditing(_ textView: UITextView) {
        if let postCardTextView = textView as? PostCardTextView, textView.text == "" {
            postCardTextView.setPlaceholder()
        }
    }
}
