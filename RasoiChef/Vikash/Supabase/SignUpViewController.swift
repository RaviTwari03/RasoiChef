//
//  SignUpViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 20/02/25.
//

import UIKit
import Supabase

class SignUpViewController: UIViewController {

    let supabase = SupabaseClient(supabaseURL: URL(string: "https://lplftokvbtoqqietgujl.supabase.co")!,
                                  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwbGZ0b2t2YnRvcXFpZXRndWpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4NzA2NzQsImV4cCI6MjA1NTQ0NjY3NH0.2EOleVodMu4KFH2Zn6jMyXniMckbTdKlf45beahOlHM")

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert("Please fill in all fields")
            return
        }

        guard password == confirmPassword else {
            showAlert("Passwords do not match")
            return
        }

        Task {
            do {
                let _ = try await supabase.auth.signUp(email: email, password: password)
                showAlert("Signup successful! Please verify your email.")
            } catch {
                showAlert("Signup failed: \(error.localizedDescription)")
            }
        }
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
