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
    
    var roverImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = roverImage {
            roverImageView.image = image
        }
    }
    
    @IBAction func sendPressed(_ sender: UIBarButtonItem) {
        
        let mailComposer = configureMailController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposer, animated: true, completion: nil)
        } else {
            showMailError()
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
        
        return mailComposer
    }
    
    func showMailError() {
        let mailErrorAlert = UIAlertController(title: "Mail Send Error", message: "Could not send email", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        mailErrorAlert.addAction(action)
        self.present(mailErrorAlert, animated: true, completion: nil)
    }
}
