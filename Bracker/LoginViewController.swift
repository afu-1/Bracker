//
//  LoginViewController.swift
//  Bracker
//
//  Created by Annie Fu on 11/18/23.
//
// Description: login page for existing users

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hides password field
        passwordTextField.isSecureTextEntry = true
        
        //enables tap gestures for dismissal of keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //segues to main page if users are logged in
        Auth.auth().addStateDidChangeListener() {
            (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.emailTextField = nil
                self.passwordTextField = nil
            }
        }
    }
    
    //dismisses keyboard when tapped outside
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //logs in users when login button is pressed
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (authResult, error) in
            if let error = error as NSError? {
                self.errorMessage.text = "\(error.localizedDescription)"
                print(error.localizedDescription)
            } else {
                self.errorMessage.text = ""
            }
        }
    }
}
