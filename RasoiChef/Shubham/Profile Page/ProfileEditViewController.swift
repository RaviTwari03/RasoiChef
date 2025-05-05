//
//  ProfileEditViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 25/01/25.
//

import UIKit

    protocol EditProfileDelegate: AnyObject {
        func didUpdateProfile(name: String, email: String, profileImage: UIImage?)
    }

    class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @IBOutlet weak var nameTextField: UITextField!
        
        @IBOutlet weak var emailTextField: UITextField!
        
        @IBOutlet weak var profileImageView: UIImageView!
        
        weak var delegate: EditProfileDelegate?

            var name: String?
            var email: String?

            override func viewDidLoad() {
                super.viewDidLoad()
                // Populate the text fields with existing data
                nameTextField.text = name
                emailTextField.text = email
                
                if let imageData = UserDefaults.standard.data(forKey: "userProfileImage"),
                       let image = UIImage(data: imageData) {
                        profileImageView.image = image
                    }
            }
        
        
        @IBAction func editImageButtonTapped(_ sender: Any) {
            let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true // if you want to allow cropping
                present(imagePicker, animated: true, completion: nil)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            var selectedImage: UIImage?
            
            if let editedImage = info[.editedImage] as? UIImage {
                selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                selectedImage = originalImage
            }
            
            if let image = selectedImage {
                profileImageView.image = image
            }
            
            dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }

        
            @IBAction func updateButtonTapped(_ sender: UIButton) {
                // Validate and pass back updated values
                if let updatedName = nameTextField.text, !updatedName.isEmpty,
                           let updatedEmail = emailTextField.text, !updatedEmail.isEmpty {
                            delegate?.didUpdateProfile(name: updatedName, email: updatedEmail, profileImage: profileImageView.image)
                            dismiss(animated: true, completion: nil) // Close modal
                        } else {
                            // Show alert if fields are empty
                            let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            present(alert, animated: true)
                        }
                    }
        
        
        
        
    }

