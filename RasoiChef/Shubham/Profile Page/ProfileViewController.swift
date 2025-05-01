//
//  ProfileViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 25/01/25.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {

//    @IBOutlet weak var profileImageView: UIImageView!
      @IBOutlet weak var nameLabel: UILabel!
      @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewShadow1: UIView!
    @IBOutlet weak var viewShadow2: UIView!
    @IBOutlet weak var viewShadow3: UIView!
    
    override func viewDidLoad() {
          super.viewDidLoad()
          // Load initial data
          loadProfileData()
        setupShadow()
          }

          override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              // Reload profile data every time the view appears
              loadProfileData()
          }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        let favouriteSwiftUIView = favouritesView()
            let hostingController = UIHostingController(rootView: NavigationView { favouriteSwiftUIView })

            navigationController?.pushViewController(hostingController, animated: true)
    }
    
    
    
    func loadProfileData() {
        let savedName = UserDefaults.standard.string(forKey: "userName") ?? "User"
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""

        nameLabel.text = savedName
        emailLabel.text = savedEmail
        
    }
    func setupShadow() {
        viewShadow.layer.shadowColor = UIColor.black.cgColor
        viewShadow.layer.shadowOpacity = 0.5
        viewShadow.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewShadow.layer.shadowRadius = 2.5
        viewShadow.layer.masksToBounds = false
        viewShadow1.layer.shadowColor = UIColor.black.cgColor
        viewShadow1.layer.shadowOpacity = 0.5
        viewShadow1.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewShadow1.layer.shadowRadius = 2.5
        viewShadow1.layer.masksToBounds = false
        viewShadow2.layer.shadowColor = UIColor.black.cgColor
        viewShadow2.layer.shadowOpacity = 0.5
        viewShadow2.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewShadow2.layer.shadowRadius = 2.5
        viewShadow2.layer.masksToBounds = false
        viewShadow3.layer.shadowColor = UIColor.black.cgColor
        viewShadow3.layer.shadowOpacity = 0.5
        viewShadow3.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewShadow3.layer.shadowRadius = 2.5
        viewShadow3.layer.masksToBounds = false
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

