//
//  RoverPostCardController.swift
//  NASA
//
//  Created by Gavin Butler on 28-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import MessageUI

class RoverPostCardController: UIViewController {
    
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var textView: PostCardTextView!
    
    
    var roverImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = roverImage {
            roverImageView.image = image
            textView.setPlaceholder()
        }
        
        //Set the UITextView delegate and returnKey type.
        textView.delegate = self
        textView.returnKeyType = .done
    }
    
    @IBAction func sendPressed(_ sender: UIBarButtonItem) {
        
        let mailComposer = configureMailController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposer, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    @IBAction func textViewPanning(_ sender: UIPanGestureRecognizer) {
        guard let recognizerView = sender.view else { return }

        let translation = sender.translation(in: view)
        recognizerView.center.x += translation.x
        recognizerView.center.y += translation.y
        sender.setTranslation(.zero, in: view)
    }
    
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

extension RoverPostCardController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["gavin.butler01@bigpond.com"])
        mailComposer.setSubject("Greetings from Mars")
        mailComposer.setMessageBody("Greetings from Mars", isHTML: true)

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
    
    func showMailError() {
        let mailErrorAlert = UIAlertController(title: "Mail Send Error", message: "Could not send email", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        mailErrorAlert.addAction(action)
        self.present(mailErrorAlert, animated: true, completion: nil)
    }
}

//  MARK: - UITextView Delegate methods to support placeholder text behaviour
extension RoverPostCardController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textView = textView as? PostCardTextView, !textView.placeholderRemoved {
            textView.setForEditing(withIntialText: "")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Textview did end editing")
        if let postCardTextView = textView as? PostCardTextView, textView.text == "" {
            postCardTextView.setPlaceholder()
        }
    }
}
