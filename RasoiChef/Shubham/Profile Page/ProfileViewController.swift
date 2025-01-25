//
//  ProfileViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 25/01/25.
//

import UIKit

class ProfileViewController: UIViewController {

//    @IBOutlet weak var profileImageView: UIImageView!
      @IBOutlet weak var nameLabel: UILabel!
      @IBOutlet weak var emailLabel: UILabel!

      override func viewDidLoad() {
          super.viewDidLoad()
          // Load initial data
          loadProfileData()
          }

          override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              // Reload profile data every time the view appears
              loadProfileData()
          }
    
    
    func loadProfileData() {
            let savedName = UserDefaults.standard.string(forKey: "userName") ?? "Shubham Jaiswal"
            let savedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "shubham22445@gmail.com"

            // Update the labels with saved or default data
        nameLabel.text = savedName
        emailLabel.text = savedEmail
        }

      // Prepare for segue to EditProfileViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "editProfileSegue",
               let editVC = segue.destination as? ProfileEditViewController {
                // Pass current name and email to the Edit Profile screen
                editVC.name = nameLabel.text
                editVC.email = emailLabel.text
                editVC.delegate = self
            }
        }
    }

  // Extend ProfileViewController to conform to the delegate
extension ProfileViewController: EditProfileDelegate {
    func didUpdateProfile(name: String, email: String) {
        // Update the profile labels
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(email, forKey: "userEmail")

        nameLabel.text = name
        emailLabel.text = email
    }
}
