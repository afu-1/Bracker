//
//  ViewController.swift
//  Bracker
//
//  Created by Annie Fu on 11/10/23.
//
// Description: The main view controller - aka the bookshelf. This specific swift file edits the book shelf and serves as the main page for users.

import UIKit
import FirebaseAuth
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

var darkMode: Bool = false
var fontSizeIndicator: Int = 1

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, BookshelfBookReviewUpdater {

    @IBOutlet var collectionView: UICollectionView!
    
    let reuseIdentifier = "bookCoverCell"
    var books = [UIImage]()
    var tempBook = BookReviewInformation()
    
    var delegate: UIViewController!
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //obtain user information - stored through Core Data so everything is stored locally to the device
        let resultUser = obtainSpecificUser()
        
        if resultUser.count > 0 {
            obtainUserInfo(cUser: resultUser[0])
        } else if resultUser.count == 0 {
            setNewUser()
        }
        
        //arbirtrary code for collection view to work
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //sets dark/light mode of app
        if darkMode == true {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
        //gestures for delete function
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressDeleteCell(gestureRecognizer: )))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        longPressGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressGesture)
        
        //retrieve local list of books per app
        let results = retrieveBookReviews()
        
        if results.count > 0 {
            for result in results {
                tempBook.title = result.value(forKey: "title") as? String ?? ""
                tempBook.author = result.value(forKey: "author") as? String ?? ""
                tempBook.summary = result.value(forKey: "summary") as? String ?? ""
                tempBook.review = result.value(forKey: "review") as? String ?? ""
                tempBook.starCount = result.value(forKey: "starCount") as? Int ?? 0
                
                let jpegData = result.value(forKey: "bookCover") as! Data
                tempBook.cover = UIImage(data: jpegData)
                
                books.append(tempBook.cover!)
            }
        }
    }
    
    //adds a new user into the local core data file
    func setNewUser(){
        let profile = UIImage(systemName: "person.crop.circle.fill")
        let jpegData = profile?.jpegData(compressionQuality: 1.0)
        
        let newUser = NSEntityDescription.insertNewObject(
                        forEntityName: "User",
                        into: context)
        
        newUser.setValue(currentUser?.uid, forKey: "userID")
        newUser.setValue(currentUser?.email, forKey: "email")
        newUser.setValue(UserDefaults.standard.value(forKey: "userName"), forKey: "name")
        newUser.setValue(UserDefaults.standard.value(forKey: "userPassword"), forKey: "password")
        newUser.setValue(jpegData, forKey: "profilePic")
        saveContext()
        
        print("saved user info!")
    }
    
    //if user is already in core data file
    func obtainUserInfo(cUser: NSManagedObject) {
        let userName = cUser.value(forKey: "name") as? String ?? ""
        let userEmail = currentUser?.email
        let userPassword = UserDefaults.standard.value(forKey: "userPassword")
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(userEmail, forKey: "userEmail")
        UserDefaults.standard.set(userPassword, forKey: "userPassword")
    }
    
    //adjusts view based on darkmode
    override func viewWillLayoutSubviews() {
        view.backgroundColor = .background
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 117, height: 175.5)
        self.collectionView.alwaysBounceVertical = true
    }
    
    //makes collection view the book cover
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! bookCell
        
        cell.bookImage.image = books[indexPath.row]
        cell.bookImage.contentMode = .scaleAspectFill
        
        return cell
    }
    
    //sets the amount of books that should be shown
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    //delete function by long pressing the book
    @IBAction func longPressDeleteCell(gestureRecognizer: UILongPressGestureRecognizer) {
            if (gestureRecognizer.state != .began) {
                return
            }

            let p = gestureRecognizer.location(in: collectionView)
            
            //alert to ensure that user wants to delete the book from the app
            if let indexPath = collectionView?.indexPathForItem(at: p) {
                let deleteAction = UIAlertController(
                    title: "Delete Book Review",
                    message: "This book will permanently be deleted from your bookshelf.",
                    preferredStyle: .alert)
                
                deleteAction.addAction(UIAlertAction(title: "Delete", style: .destructive, handler : {
                    (action) in let idx = indexPath.row
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName:"BookReview")
                    var fetchedResults: [NSManagedObject]
                    
                    //deletes from core data
                    do {
                        try fetchedResults = context.fetch(request) as! [NSManagedObject]
                        context.delete(fetchedResults[indexPath.row])
                        self.saveContext()
                    } catch {
                        print("Error occurred while trying to delete data")
                        abort()
                    }
                    
                    self.books.remove(at: idx)
                    self.collectionView.reloadData()
                }))
                deleteAction.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(deleteAction, animated: true)
            }
        }
    
    //updates the bookshelf with a new book
    func updateBookshelf(book: BookReviewInformation) {
        books.append(book.cover!)
        let userID = Auth.auth().currentUser!.uid
        
        let jpegData = book.cover?.jpegData(compressionQuality: 1.0)
        
        let bookReviewInd = NSEntityDescription.insertNewObject(
            forEntityName: "BookReview",
            into: context)
        
        bookReviewInd.setValue("\(userID) \(books.count)", forKey: "userID")
        bookReviewInd.setValue(book.title, forKey: "title")
        bookReviewInd.setValue(book.author, forKey: "author")
        bookReviewInd.setValue(book.summary, forKey: "summary")
        bookReviewInd.setValue(book.review, forKey: "review")
        bookReviewInd.setValue(book.starCount, forKey: "starCount")
        bookReviewInd.setValue(jpegData, forKey: "bookCover")
        
        saveContext()
        collectionView.reloadData()
    }
    
    //updates old book information
    func updateBook(book: BookReviewInformation, idx: Int) {
        let jpegData = book.cover?.jpegData(compressionQuality: 1.0)
        
        //core data update
        let bookReviewInd = obtainSpecificBook(index: idx)
        
        bookReviewInd.setValue(book.title, forKey: "title")
        bookReviewInd.setValue(book.author, forKey: "author")
        bookReviewInd.setValue(book.summary, forKey: "summary")
        bookReviewInd.setValue(book.review, forKey: "review")
        bookReviewInd.setValue(book.starCount, forKey: "starCount")
        bookReviewInd.setValue(jpegData, forKey: "bookCover")
        
        saveContext()
        
        //collection view update
        books[idx] = UIImage(data: jpegData ?? Data())!
        collectionView.reloadData()
    }
    
    //saves data into core data
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
    
    //function to retrieve all book reviews from core data
    func retrieveBookReviews() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BookReview")
        var fetchedResults: [NSManagedObject]? = nil
        
        let userID = Auth.auth().currentUser!.uid //filters out books for this specific user
        let predicate = NSPredicate(format: "userID CONTAINS[c] '\(userID)'")
        request.predicate = predicate
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occurred while retrieving data")
            abort()
        }
        
        return (fetchedResults)!
    }
    
    //function to retrieve only 1 book from core data
    func obtainSpecificBook(index: Int) -> NSManagedObject {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BookReview") //create a request
        var fetchedResults: [NSManagedObject]? = nil //if get an answer, put in results
        
        let userID = Auth.auth().currentUser!.uid //filters out for books listed by this specific ussr
        
        let predicate = NSPredicate(format: "userID CONTAINS[c] '\(userID) \(index + 1)'")
        request.predicate = predicate
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occurred while retrieving data")
            abort()
        }
        
        return (fetchedResults![0])
    }
    
    //function to obtain 1 user from core data
    func obtainSpecificUser() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User") //create a request
        var fetchedResults: [NSManagedObject]? = nil //if get an answer, put in results
        
        let userID = Auth.auth().currentUser!.uid
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
    
    //segues for popover and book reviews
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue",
           let popoverVC = segue.destination as? PopoverViewController{
            
            //following code is from https://medium.com/@biz84/ios-segues-tips-and-tricks-78847484d2ba
                        
            popoverVC.modalPresentationStyle = UIModalPresentationStyle.popover
            if let popover = popoverVC.popoverPresentationController {
                popover.delegate = self
            }
            
            //segue for old book review
        } else if segue.identifier == "bookReviewSegue",
                  let oldBookReviewVC = segue.destination as? OldBookReviewViewController {
            if let indexPath = collectionView.indexPathsForSelectedItems {
                oldBookReviewVC.delegate = self
                
                let idx = indexPath[0][0] + indexPath[0][1]
                let specificBook = obtainSpecificBook(index: idx) //obtains book at specific index
                
                //sets a temporary book class with information from core data
                tempBook.title = specificBook.value(forKey: "title") as? String ?? ""
                tempBook.author = specificBook.value(forKey: "author") as? String ?? ""
                tempBook.summary = specificBook.value(forKey: "summary") as? String ?? ""
                tempBook.review = specificBook.value(forKey: "review") as? String ?? ""
                tempBook.starCount = specificBook.value(forKey: "starCount") as? Int ?? 0
                
                let jpegData = specificBook.value(forKey: "bookCover") as! Data
                tempBook.cover = UIImage(data: jpegData)
                
                //sends book and index to review page
                oldBookReviewVC.bookReviewIndividual = tempBook
                oldBookReviewVC.bookIndex = idx
            }
            
            //segue for new book review
        } else if segue.identifier == "newBookReviewSegue",
                  let newBookReviewVC = segue.destination as? BookReviewViewController {
            newBookReviewVC.delegate = self
        }
    }
}

