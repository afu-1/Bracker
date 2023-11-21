//
//  UserClass.swift
//  Bracker
//
//  Created by Annie Fu on 11/21/23.
//
// Description: user class to store users for easier access in other code

import UIKit

class UserClass: NSObject {
    var userName:String = ""
    var userPassword:String = ""
    var userEmail:String = ""
    var userProfilePic:UIImage?
    
    //changes user's name
    func changeUserName(newName: String){
        self.userName = newName
    }
    
    //changes user password
    func changeUserPassword(newPassword: String) {
        self.userPassword = newPassword
    }
    
    //changes user email
    func changeUserEmail(newEmail: String) {
        self.userEmail = newEmail
    }
    
    //changes user picture
    func changeUserProfilePic(newProfilePic: UIImage) {
        self.userProfilePic = newProfilePic
    }
}
