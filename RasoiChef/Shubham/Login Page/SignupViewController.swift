//
//  SignupViewController.swift
//  LoginPage
//
//  Created by Shubham Jaiswal on 24/01/25.
//

import UIKit

// Protocol to communicate between SignupViewController and LoginViewController
protocol SignupViewControllerDelegate: AnyObject { // Use AnyObject to restrict to class types
    func didRegisterUser(username: String, password: String)
}

class SignupViewController: UIViewController {
    
    
    @IBOutlet var UsernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var confirmTextField: UITextField!
    
    
    
    weak var delegate: SignupViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func registerButtonTapped(_ sender: Any) {

        let username = UsernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
           let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
           let confirmPassword = confirmTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

           if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
               showAlert(title: "Error", message: "Please fill in all fields.")
               return
           }

           if password != confirmPassword {
               showAlert(title: "Error", message: "Passwords do not match.")
               return
           }

           // Save credentials
           UserDefaults.standard.set(username, forKey: "registeredUsername")
           UserDefaults.standard.set(password, forKey: "registeredPassword")
           print("Saved Username: \(username), Password: \(password)")

           // Notify delegate
           delegate?.didRegisterUser(username: username, password: password)

           // Show success message
           let alert = UIAlertController(title: "Success", message: "Account registered successfully!", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
               self.dismiss(animated: true, completion: nil)
           }))
           present(alert, animated: true, completion: nil)
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
