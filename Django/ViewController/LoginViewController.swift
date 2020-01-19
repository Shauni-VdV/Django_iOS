//
//  LoginViewController.swift
//  Django
//
//  Created by Shauni Van de Velde on 28/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import UIKit
// Log in with a TMDB account
class LoginViewController : UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EmailTextField.text = ""
        PasswordTextField.text = ""


    }
    
    // When the login button is tapped, start the login process.
    // First we need to get a request token.
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        ApiClient.getRequestToken(completion: handleRequestToken(success: error:))
    }
    
    // Then we pass the email and password
    func handleRequestToken(success: Bool, error: Error?) {
        if success{
            ApiClient.login(username: EmailTextField.text ?? "", password: PasswordTextField.text ?? "", completion: handleLogin(success:error:))
        } else {
            showLoginFailed(message: error?.localizedDescription ?? "")
        }
    }

    // Check if the login was successful, if so continue to the session part
    func handleLogin(success: Bool, error: Error?) {
        if success {
            ApiClient.postSessionId(completion: handleSession(success:error:))
        } else {
            showLoginFailed(message: error?.localizedDescription ?? "")
        }
    }
    
    // If the session was handled successfully, navigate out of the login screen
    func handleSession(success: Bool, error: Error?){
        if success {
            _ = navigationController?.popViewController(animated: true)

        } else {
            showLoginFailed(message: error?.localizedDescription ?? "")
        }
    }
    
    // Show alert if login was not successful.
    func showLoginFailed(message: String){
        let alertVC = UIAlertController(title: "Login not successful", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
