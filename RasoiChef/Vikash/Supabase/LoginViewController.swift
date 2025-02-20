//
//  LoginViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 20/02/25.
//

import UIKit
import Supabase

class LoginViewController: UIViewController {
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://lplftokvbtoqqietgujl.supabase.co")!,
                                      supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwbGZ0b2t2YnRvcXFpZXRndWpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4NzA2NzQsImV4cCI6MjA1NTQ0NjY3NH0.2EOleVodMu4KFH2Zn6jMyXniMckbTdKlf45beahOlHM")
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginTapped(_ sender: UIButton) {
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                showAlert("Please enter email and password")
                return
            }

            Task {
                do {
                    let session = try await supabase.auth.signIn(email: email, password: password)
                    navigateToHome()
                } catch {
                    showAlert("Login failed: \(error.localizedDescription)")
                }
            }
        }

        @IBAction func signUpTapped(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                self.navigationController?.pushViewController(signUpVC, animated: true)
        }

        func navigateToHome() {
            DispatchQueue.main.async {
                let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingPageViewController")
                self.navigationController?.setViewControllers([homeVC], animated: true)

            }
        }

        func showAlert(_ message: String) {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

}
