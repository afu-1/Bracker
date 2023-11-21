//
//  PopoverViewController.swift
//  Bracker
//
//  Created by Annie Fu on 11/19/23.
//
// Description: view of popover and functionality of popover

import UIKit
import FirebaseAuth

class PopoverViewController: UIViewController {
    
    var delegate: UIViewController!

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set dark mode of popover menu
        if darkMode == true {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    //set colors for popover menu
    override func viewWillLayoutSubviews() {
        view.backgroundColor = .background
        profileButton.tintColor = UIColor(named: "labelColor")
        settingsButton.tintColor = UIColor(named: "labelColor")
    }
    
    //log out user
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
}
