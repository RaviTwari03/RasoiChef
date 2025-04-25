//
//  ProfileViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 25/01/25.
//

import UIKit
import Supabase
import SwiftUI

class ProfileViewController: UIViewController {

//    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private let supabase = SupabaseController.shared.client
    
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
        let savedName = UserDefaults.standard.string(forKey: "userName") ?? "User"
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""

        nameLabel.text = savedName
        emailLabel.text = savedEmail
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
