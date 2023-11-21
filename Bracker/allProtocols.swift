//
//  allProtocols.swift
//  Bracker
//
//  Created by Annie Fu on 11/19/23.
//
// Description: store all protocols used for app

import UIKit

protocol BookshelfBookReviewUpdater {
    func updateBookshelf(book: BookReviewInformation) //updates the bookshelf with a new book
    func updateBook(book: BookReviewInformation, idx: Int) //updates the old book with new info
}
