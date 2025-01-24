//
//  ViewController.swift
//  LoginPage
//
//  Created by Shubham Jaiswal on 20/01/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    var registeredUsername: String?
    var registeredPassword: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {

        
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if username.isEmpty || password.isEmpty {
            showAlert(title: "Error", message: "Please enter both username and password.")
            return
        }

        let registeredUsername = UserDefaults.standard.string(forKey: "registeredUsername")
        let registeredPassword = UserDefaults.standard.string(forKey: "registeredPassword")


        if username == registeredUsername && password == registeredPassword {
            
                    // Show alert and navigate to LandingPageViewController
                    let alert = UIAlertController(title: "Success", message: "Login successful!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Perform segue after alert is dismissed
                        self.performSegue(withIdentifier: "LandingPageViewController", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    showAlert(title: "Error", message: "Invalid username or password.")
                }
    }

    
    @IBAction func signupButtonTapped(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signupVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
            signupVC.delegate = self
            self.present(signupVC, animated: true, completion: nil)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "GoToSignUp" {
                let signupVC = segue.destination as? SignupViewController
                signupVC?.delegate = self
            }
        }
        
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - SignupViewControllerDelegate
    extension LoginViewController: SignupViewControllerDelegate {
        func didRegisterUser(username: String, password: String) {
            registeredUsername = username
            registeredPassword = password
        }
    }



