//
//  BookDetailPresenter.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 17.05.2024.
//

import Foundation
import CoreData

protocol BookDetailViewProtocol: AnyObject {
    func displayBook(_ book: Book)
    func displayError(_ error: String)
    func dismiss()
}

class BookDetailPresenter {
    private weak var view: BookDetailViewProtocol?
    private let context: NSManagedObjectContext
    private var book: Book?
    
    init(view: BookDetailViewProtocol, context: NSManagedObjectContext, book: Book? = nil) {
        self.view = view
        self.context = context
        self.book = book
    }
    
    func viewDidLoad() {
        if let book = book {
            view?.displayBook(book)
        }
    }
    
    func saveBook(title: String, author: String, year: Int16) {
        if let book = book {
            book.title = title
            book.author = author
            book.year = year
        } else {
            let book = Book(context: context)
            book.title = title
            book.author = author
            book.year = year
        }
        saveContext()
        view?.dismiss()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            view?.displayError("Failed to save context")
        }
    }
}

