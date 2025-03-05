//
//  LoginViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 20/02/25.
//

import UIKit
import Supabase

class LoginViewController: UIViewController , UITextFieldDelegate{
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://lplftokvbtoqqietgujl.supabase.co")!,
                                      supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwbGZ0b2t2YnRvcXFpZXRndWpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4NzA2NzQsImV4cCI6MjA1NTQ0NjY3NH0.2EOleVodMu4KFH2Zn6jMyXniMckbTdKlf45beahOlHM")
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.isHidden = true
        
        
        // Set text field delegates
               emailTextField.delegate = self
               passwordTextField.delegate = self

                // Add target to detect text change
                emailTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
                passwordTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
            }

    

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Please enter email and password"
            errorLabel.isHidden = false
            return
        }

        Task {
            do {
                let session = try await supabase.auth.signIn(email: email, password: password)

                //  Save logged-in email to UserDefaults
                UserDefaults.standard.set(email, forKey: "userEmail")

                // Retrieve user name from Supabase or set a default name
                let savedName = UserDefaults.standard.string(forKey: "userName") ?? "User"
                UserDefaults.standard.set(savedName, forKey: "userName")

                // Hide error message if login is successful
                errorLabel.isHidden = true

                // Navigate to Home
                navigateToHome()
            } catch {
                errorLabel.text = "Login failed: \(error.localizedDescription)"
                errorLabel.isHidden = false
            }
        }
    }
    @objc func textFieldsDidChange(_ textField: UITextField) {
        errorLabel.isHidden = true
    }

    // Dismiss keyboard when return key is pressed
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Hides the keyboard
            return true
        }
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }


        @IBAction func signUpTapped(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                self.navigationController?.pushViewController(signUpVC, animated: true)
            
        }

    func navigateToHome() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
            
            // If there's a navigation controller, set the new root without embedding it in another navigation stack
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = homeVC
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }



        func showAlert(_ message: String) {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

}
