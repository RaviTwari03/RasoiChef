//
//  ProfileEditViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 25/01/25.
//

import UIKit

    protocol EditProfileDelegate: AnyObject {
        func didUpdateProfile(name: String, email: String)
    }

    class ProfileEditViewController: UIViewController {
        
        @IBOutlet weak var nameTextField: UITextField!
        
        @IBOutlet weak var emailTextField: UITextField!
        
        
        weak var delegate: EditProfileDelegate?

            var name: String?
            var email: String?

            override func viewDidLoad() {
                super.viewDidLoad()
                // Populate the text fields with existing data
                nameTextField.text = name
                emailTextField.text = email
            }
        
        

            @IBAction func updateButtonTapped(_ sender: UIButton) {
                // Validate and pass back updated values
                if let updatedName = nameTextField.text, !updatedName.isEmpty,
                           let updatedEmail = emailTextField.text, !updatedEmail.isEmpty {
                            delegate?.didUpdateProfile(name: updatedName, email: updatedEmail)
                            dismiss(animated: true, completion: nil) // Close modal
                        } else {
                            // Show alert if fields are empty
                            let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            present(alert, animated: true)
                        }
                    }
        
        
        
        
    }

