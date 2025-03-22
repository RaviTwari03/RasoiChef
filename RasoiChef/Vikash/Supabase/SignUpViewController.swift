//
//  SignUpViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 20/02/25.
//

import UIKit
import Supabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    let supabase = SupabaseController.shared.client

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordMismatchLabel: UILabel!

    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Set text field delegates
               emailTextField.delegate = self
               passwordTextField.delegate = self
               confirmPasswordTextField.delegate = self
               nameTextField.delegate = self
        
        
        // Initially hide the password mismatch label
        passwordMismatchLabel.isHidden = true

        // Set up text field change detection
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.addTarget(self, action: #selector(validatePasswordMatch), for: .editingChanged)
    }

    @objc func validatePasswordMatch() {
        if let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            if password != confirmPassword {
                passwordMismatchLabel.text = "Passwords don't match"
                passwordMismatchLabel.isHidden = false
            } else {
                passwordMismatchLabel.isHidden = true
            }
        }
    }

    @IBAction func registerTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert("Please fill in all fields")
            return
        }

        guard password == confirmPassword else {
            passwordMismatchLabel.text = "Passwords do not match"
            passwordMismatchLabel.isHidden = false
            return
        }

        Task {
            do {
                let _ = try await supabase.auth.signUp(email: email, password: password)
                
                // Save name and email in UserDefaults
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.set(email, forKey: "userEmail")

                showAlertAndNavigate("Signup successful! Please verify your email.")
            } catch {
                showAlert("Signup failed: \(error.localizedDescription)")
            }
        }
    }

    // Show alert and navigate to LoginViewController on "OK"
    func showAlertAndNavigate(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigateToLogin()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    // Dismiss keyboard when return key is pressed
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Hides the keyboard
            return true
        }
    
    // Function to navigate to LoginViewController
    func navigateToLogin() {
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true)
            }
        }

    // Function to show a simple alert
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
