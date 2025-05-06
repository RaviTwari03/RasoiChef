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
    private let supabase = SupabaseController.shared.client
    
    
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
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        // Show confirmation alert
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
        Task {
            do {
                // Sign out from Supabase
                try await supabase.auth.signOut()
                
                // Clear UserDefaults
                UserDefaults.standard.removeObject(forKey: "userEmail")
                UserDefaults.standard.removeObject(forKey: "userName")
                
                // Switch to LoginView
                await MainActor.run {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        let loginView = LoginView()
                        let hostingController = UIHostingController(rootView: loginView)
                        
                        UIView.transition(with: window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {
                            window.rootViewController = hostingController
                        })
                        window.makeKeyAndVisible()
                    }
                }
            } catch {
                print("Error during logout: \(error)")
                let alert = UIAlertController(
                    title: "Logout Error",
                    message: "Failed to logout. Please try again.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
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
