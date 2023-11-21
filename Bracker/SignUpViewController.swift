//
//  SignUpViewController.swift
//  Bracker
//
//  Created by Annie Fu on 11/18/23.
//
// Description: allows users to sign up and create an account

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var signUpErrorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hides password and confirm password
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        
        //tap gesture to allow for dismissal of keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //automatically allows users to start using app once they sign in
        Auth.auth().addStateDidChangeListener() {
            (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "signUpBookshelfSegue", sender: nil)
                self.nameField.text = nil
                self.emailField.text = nil
                self.passwordField.text = nil
                self.confirmPasswordField.text = nil
            }
        }
    }
    
    //dismisses keyboard on tap
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //signs up user into Firebase when sign up is pressed and passwords match
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if confirmPasswordField.text == passwordField.text {
            //set user defaults for core data purposes
            UserDefaults.standard.set(nameField.text, forKey: "userName")
            UserDefaults.standard.set(emailField.text, forKey: "userEmail") 
            UserDefaults.standard.set(passwordField.text, forKey: "userPassword")
            
            //creates an account in firebase
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
                (authResult, error) in
                if let error = error as NSError? {
                    self.signUpErrorMessage.text = "\(error.localizedDescription)"
                } else {
                    self.signUpErrorMessage.text = ""
                }
            }
            
        } else {
            self.signUpErrorMessage.text = "Passwords do not match."
        }
    }
}
