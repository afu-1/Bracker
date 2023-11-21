//
//  OldBookReviewViewController.swift
//  Bracker
//
//  Created by Annie Fu on 11/20/23.
//
// Description: updates old book review with new info from user

import UIKit
import CoreData

class OldBookReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //all of the label variables
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    //all text field variables
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var summaryTextField: UITextView!
    @IBOutlet weak var reviewTextField: UITextView!
    
    //button variables
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //star ratings
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var coverImage: UIImageView!
    
    //segue information
    var delegate: UIViewController!
    let picker = UIImagePickerController()
    var bookReviewIndividual = BookReviewInformation()
    var bookIndex: Int = 0
    
    //star review gestures
    var oneStarReview = UITapGestureRecognizer()
    var twoStarReview = UITapGestureRecognizer()
    var threeStarReview = UITapGestureRecognizer()
    var fourStarReview = UITapGestureRecognizer()
    var fiveStarReview = UITapGestureRecognizer()
    var starRatings = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set dark mode if it was selected earlier
        if darkMode == true {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
        //create picker for image picker
        picker.delegate = self
        
        //set text values from previously made book review
        titleTextField.text = bookReviewIndividual.title
        authorTextField.text = bookReviewIndividual.author
        summaryTextField.text = bookReviewIndividual.summary
        reviewTextField.text = bookReviewIndividual.review
        starRatings = bookReviewIndividual.starCount
        coverImage.image = bookReviewIndividual.cover
        coverImage.contentMode = .scaleAspectFill
        
        //set star ratings from previous book review
        switch starRatings {
        case 0: //no stars
            star1.image = UIImage(systemName: "star")
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 1: //1 star
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 2: //2 stars
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 3: //3 stars
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 4: //4 stars
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star.fill")
            star5.image = UIImage(systemName: "star")
        case 5: //5 stars
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star.fill")
            star5.image = UIImage(systemName: "star.fill")
        default:
            print("this should not happen")
        }
        
        //set tap gestures for each star
        
        //1 star
        oneStarReview = UITapGestureRecognizer(target: self, action: #selector(starReviewTap(recognizer:)))
        star1.isUserInteractionEnabled = true
        star1.addGestureRecognizer(oneStarReview)
        
        //2 star
        twoStarReview = UITapGestureRecognizer(target: self, action: #selector(starReviewTap(recognizer:)))
        star2.isUserInteractionEnabled = true
        star2.addGestureRecognizer(twoStarReview)
        
        //3 star
        threeStarReview = UITapGestureRecognizer(target: self, action: #selector(starReviewTap(recognizer:)))
        star3.isUserInteractionEnabled = true
        star3.addGestureRecognizer(threeStarReview)
        
        //4 star
        fourStarReview = UITapGestureRecognizer(target: self, action: #selector(starReviewTap(recognizer:)))
        star4.isUserInteractionEnabled = true
        star4.addGestureRecognizer(fourStarReview)
        
        //5star
        fiveStarReview = UITapGestureRecognizer(target: self, action: #selector(starReviewTap(recognizer:)))
        star5.isUserInteractionEnabled = true
        star5.addGestureRecognizer(fiveStarReview)
        
        //set font sizes of book reviews
        switch fontSizeIndicator {
        case 1: //small
            titleTextField.font = UIFont.init(name: "JosefinSans-Light", size: 12.0)
            authorTextField.font = UIFont.init(name: "JosefinSans-Light", size: 12.0)
            summaryTextField.font = UIFont.init(name: "JosefinSans-Light", size: 12.0)
            reviewTextField.font = UIFont.init(name: "JosefinSans-Light", size: 12.0)
        case 2: //medium
            titleTextField.font = UIFont.init(name: "JosefinSans-Light", size: 16.0)
            authorTextField.font = UIFont.init(name: "JosefinSans-Light", size: 16.0)
            summaryTextField.font = UIFont.init(name: "JosefinSans-Light", size: 16.0)
            reviewTextField.font = UIFont.init(name: "JosefinSans-Light", size: 16.0)
        case 3: //large
            titleTextField.font = UIFont.init(name: "JosefinSans-Light", size: 20.0)
            authorTextField.font = UIFont.init(name: "JosefinSans-Light", size: 20.0)
            summaryTextField.font = UIFont.init(name: "JosefinSans-Light", size: 20.0)
            reviewTextField.font = UIFont.init(name: "JosefinSans-Light", size: 20.0)
        default:
            print("this should not happen")
        }
        
        //tap gesture for dismissing keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    //set colors of dark and light modes
    override func viewWillLayoutSubviews() {
        view.backgroundColor = .background
        
        //label colors
        titleLabel.textColor = UIColor(named: "labelColor")
        authorLabel.textColor = UIColor(named: "labelColor")
        summaryLabel.textColor = UIColor(named: "labelColor")
        reviewLabel.textColor = UIColor(named: "labelColor")
        
        //text box colors
        titleTextField.backgroundColor = UIColor(named: "textBoxColor")
        authorTextField.backgroundColor = UIColor(named: "textBoxColor")
        summaryTextField.backgroundColor = UIColor(named: "textBoxColor")
        reviewTextField.backgroundColor = UIColor(named: "textBoxColor")
        
        //star colors
        star1.tintColor = UIColor(named: "labelColor")
        star2.tintColor = UIColor(named: "labelColor")
        star3.tintColor = UIColor(named: "labelColor")
        star4.tintColor = UIColor(named: "labelColor")
        star5.tintColor = UIColor(named: "labelColor")
        
        //button colors
        addButton.backgroundColor = UIColor(named: "textBoxColor")
        
        saveButton.titleLabel?.textColor = UIColor(named: "labelColor")
        saveButton.backgroundColor = UIColor(named: "buttonColor")
        saveButton.layer.cornerRadius = 10.0
        
        //removes button image if there is a cover image set
        if coverImage.image != nil {
            addButton.backgroundColor = UIColor.clear
            addButton.titleLabel?.text = ""
        }
    }
    
    //dismisses keyboard when tapped outside
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //allows users to add a image cover for the book they are reviewing
    @IBAction func addCoverButtonPressed(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    //selects an image to display for book cover
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // get the selected image
        let chosenImage = info[.originalImage] as! UIImage
        
        // shrink it to a visible size
        coverImage.contentMode = .scaleAspectFill
        
        // put the picture into the imageView
        coverImage.image = chosenImage
        
        // dismiss the popover
        dismiss(animated: true)
    }
    
    //saves book review if all text fields and book cover is put in
    @IBAction func saveButtonPressed(_ sender: Any) {
        if titleTextField.text!.isEmpty != true && authorTextField.text!.isEmpty != true && summaryTextField.text!.isEmpty != true && reviewTextField.text!.isEmpty != true {
            bookReviewIndividual.setTitle(newTitle: titleTextField.text!)
            bookReviewIndividual.setAuthor(newAuthor: authorTextField.text!)
            bookReviewIndividual.setSummary(newSummary: summaryTextField.text!)
            bookReviewIndividual.setReview(newReview: reviewTextField.text!)
            bookReviewIndividual.setBookCover(newBookCover: coverImage.image!)
            bookReviewIndividual.setStarCount(totalStars: starRatings)
            
            //updates old book review
            let mainVC = delegate as! BookshelfBookReviewUpdater
            mainVC.updateBook(book: bookReviewIndividual, idx: bookIndex)
            
        } else {
            //brings alert message that book review is not completed
            let preventSavingAction = UIAlertController(
                title: "All fields are not filled!",
                message: "You still need to fill out some fields before saving!",
                preferredStyle: .alert)

            preventSavingAction.addAction(UIAlertAction(title: "OK", style: .default))
            present(preventSavingAction, animated: true)
        }
    }
    
    //tap gestures for star ratings for users
    @IBAction func starReviewTap(recognizer: UITapGestureRecognizer) {
        switch recognizer {
        case oneStarReview:
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
            starRatings = 1
            
        case twoStarReview:
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
            starRatings = 2
            
        case threeStarReview:
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
            starRatings = 3
            
        case fourStarReview:
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star.fill")
            star5.image = UIImage(systemName: "star")
            starRatings = 4
            
        case fiveStarReview:
            star1.image = UIImage(systemName: "star.fill")
            star2.image = UIImage(systemName: "star.fill")
            star3.image = UIImage(systemName: "star.fill")
            star4.image = UIImage(systemName: "star.fill")
            star5.image = UIImage(systemName: "star.fill")
            starRatings = 5
            
        default:
            print("this should not happen")
        }
    }
}
