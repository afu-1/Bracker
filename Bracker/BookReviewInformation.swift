//
//  BookReviewInformation.swift
//  Bracker
//
//  Created by Annie Fu on 11/20/23.
//
// Description: Class to store information about book reviews

import UIKit

class BookReviewInformation: NSObject {
    var title:String = ""
    var author:String = ""
    var summary:String = ""
    var review:String = ""
    var cover:UIImage?
    var starCount:Int = 0
    
    //sets the title of the book
    func setTitle(newTitle: String){
        self.title = newTitle
    }
    
    //sets the author of the book
    func setAuthor(newAuthor: String) {
        self.author = newAuthor
    }
    
    //sets the paraphrased summary from the user
    func setSummary(newSummary: String) {
        self.summary = newSummary
    }
    
    //sets the review from the user
    func setReview(newReview: String) {
        self.review = newReview
    }
    
    //sets the book cover the user chooses
    func setBookCover(newBookCover: UIImage){
        self.cover = newBookCover
    }
    
    //sets the star rating count from the user
    func setStarCount(totalStars: Int) {
        self.starCount = totalStars
    }
}
