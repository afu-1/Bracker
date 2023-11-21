//
//  ProfileSettingsViewController.swift
//  Bracker
//
//  Created by Annie Fu on 11/20/23.
//
// Description: allows users to change their profile name, email, password, and pic

import UIKit
import CoreData
import FirebaseAuth
import AVFoundation

class ProfileSettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var nameLabel: UILabel! //big name label
    
    //text fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    //labels for each of the text fields
    @IBOutlet weak var nameHardLabel: UILabel!
    @IBOutlet weak var emailHardLabel: UILabel!
    @IBOutlet weak var passwordHardLabel: UILabel!
    @IBOutlet weak var confirmPasswordHardLabel: UILabel!
    
    //buttons and profile images
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    //other info needed for data reasons
    let userID = Auth.auth().currentUser!.uid
    let picker = UIImagePickerController()
    var tempUser = UserClass()
    var userInfo = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //picker for images
        picker.delegate = self
        
        //set the texts of the big name, the name field, and the email field to be of the user's info from core data
        nameLabel.text = UserDefaults.standard.string(forKey: "userName")
        nameTextField.text = UserDefaults.standard.string(forKey: "userName")
        emailTextField.text = UserDefaults.standard.string(forKey: "userEmail")
        
        //get the current user information
        let resultUser = obtainSpecificUser()
        let standardUser = resultUser[0]
        
        //set current users information as a class for easier access
        tempUser.userName = standardUser.value(forKey: "name") as? String ?? ""
        tempUser.userEmail = standardUser.value(forKey: "email") as? String ?? ""
        tempUser.userPassword = standardUser.value(forKey: "password") as? String ?? ""
        let jpegData = standardUser.value(forKey: "profilePic") as? Data ?? Data()
        tempUser.userProfilePic = UIImage(data: jpegData) ?? UIImage()
        
        //set user profile picture
        profileImage.image = tempUser.userProfilePic
        profileImage.contentMode = .scaleAspectFill
        
        //ensure that new password is hidden while typing
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        //set dark/light mode of VC
        if darkMode == true {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
        //tap gesture for keyboard dismissal
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //changes the color of the VC layout based on dark/light mode
    override func viewWillLayoutSubviews() {
        view.backgroundColor = .background
        nameLabel.textColor = UIColor(named: "labelColor") //big name label
        
        //text fields
        nameTextField.backgroundColor = UIColor(named: "textBoxColor")
        emailTextField.backgroundColor = UIColor(named: "textBoxColor")
        passwordTextField.backgroundColor = UIColor(named: "textBoxColor")
        confirmPasswordTextField.backgroundColor = UIColor(named: "textBoxColor")
        
        //hard labels indicating what each textfield is
        nameHardLabel.textColor = UIColor(named: "labelColor")
        emailHardLabel.textColor = UIColor(named: "labelColor")
        passwordHardLabel.textColor = UIColor(named: "labelColor")
        confirmPasswordHardLabel.textColor = UIColor(named: "labelColor")
        
        //buttons
        saveButton.titleLabel?.textColor = UIColor(named: "labelColor")
        saveButton.backgroundColor = UIColor(named: "buttonColor")
        saveButton.layer.cornerRadius = 10.0

        addPictureButton.titleLabel?.textColor = UIColor(named: "labelColor")
        
        //removes button image if there is a cover image set
        if profileImage.image != nil {
            addPictureButton.backgroundColor = UIColor.clear
            addPictureButton.titleLabel?.text = ""
        }
    }
    
    //dismisses keyboard when tapping outside
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }

    //saves new user info if changes were made
    @IBAction func saveButtonPressed(_ sender: Any) {
        //obtain current user
        userInfo = obtainSpecificUser()
        let standardUser = userInfo[0]
        
        //changes info of user based on whether changes were made
        //name
        if tempUser.userName != nameTextField.text! {
            standardUser.setValue(nameTextField.text!, forKey: "name")
            tempUser.changeUserName(newName: nameTextField.text!)
        }
        
        //email
        if tempUser.userEmail != emailTextField.text! {
            Auth.auth().currentUser?.updateEmail(to: emailTextField.text!)
            standardUser.setValue(nameTextField.text!, forKey: "email")
            tempUser.changeUserEmail(newEmail: emailTextField.text!)
        }
        
        //password
        if passwordTextField.text!.isEmpty == false && passwordTextField.text! != tempUser.userPassword {
            if passwordTextField.text! == confirmPasswordTextField.text! {
                Auth.auth().currentUser?.updatePassword(to: passwordTextField.text!)
                standardUser.setValue(passwordTextField.text!, forKey: "password")
                tempUser.changeUserPassword(newPassword: passwordTextField.text!)
                
            } else {
                //if different passwords in both password fields then alert error will appear
                let wrongPassword = UIAlertController(
                    title: "Passwords don't match!",
                    message: "Please make sure that your passwords match!",
                    preferredStyle: .alert)
                
                wrongPassword.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(wrongPassword, animated: true)
            }
        }
        
        //checks for changes in profile image
        let uploadedJpegData = profileImage.image?.jpegData(compressionQuality: 1.0)
        let coreJpegData = tempUser.userProfilePic?.jpegData(compressionQuality: 1.0)
        
        if uploadedJpegData != coreJpegData {
            let jpegData = uploadedJpegData
            
            standardUser.setValue(jpegData, forKey: "profilePic")
            tempUser.changeUserProfilePic(newProfilePic: profileImage.image!)
        }
        
        //saves into core data
        saveContext()
        
        //sets the user defaults to see when accessing profile page again
        UserDefaults.standard.set(nameTextField.text, forKey: "userName")
        nameLabel.text = nameTextField.text
    }
    
    //add profile picture when clicking profile button
    @IBAction func addProfilePic(_ sender: Any) {
        //pushes an action sheet alert to select between photo library or camera
        let addPic = UIAlertController(
            title: "Add a Profile Picture",
            message: "Select one of the options below to choose an option to upload your profile picture!",
            preferredStyle: .actionSheet)
        
        //cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        addPic.addAction(cancelAction)
        
        //camera action
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {
            (action) in if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                    
                //permission for usage of camera
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) {
                        accessGranted in
                        guard accessGranted == true else { return }
                    }
                case .authorized:
                    break
                default:
                    print("Access denied")
                    return
                }
                
                //pick image frmo camera
                self.picker.sourceType = .camera
                self.picker.cameraCaptureMode = .photo
                
                self.present(self.picker, animated: true)
            } else {
                // no camera is available so alert message that camera is not available
                let alertVC = UIAlertController(
                    title: "No Camera",
                    message: "Sorry, this device has no camera",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true)
            }})
        addPic.addAction(camera)
        
        //photo library action
        let library = UIAlertAction(title: "Library", style: .default, handler: {
            //take image from photo library
            (action) in self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true)
        })
        addPic.addAction(library)
        
        present(addPic, animated: true)
    }
    
    //function to make the profile pic the image chosen either from library or taken from camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get the selected image
        let chosenImage = info[.originalImage] as! UIImage
        
        // shrink it to a visible size
        profileImage.contentMode = .scaleAspectFill
        
        // put the picture into the imageView
        profileImage.image = chosenImage
        
        // dismiss the popover
        dismiss(animated: true)
    }
    
    //segues back to main bookshelf VC
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //returns a specific user that has been requested
    func obtainSpecificUser() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User") //create a request
        var fetchedResults: [NSManagedObject]? = nil //if get an answer, put in results
        
        let userID = Auth.auth().currentUser!.uid //get userID of current user
        let predicate = NSPredicate(format: "userID = '\(userID)'")
        request.predicate = predicate
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occurred while retrieving data")
            abort()
        }
        
        return (fetchedResults)!
    }
    
    //saves core data
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
