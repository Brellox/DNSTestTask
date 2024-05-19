//
//  BooksListPresenter.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 17.05.2024.
//

import Foundation
import CoreData

protocol BookListViewProtocol: AnyObject {
    func displayBooks(_ books: [Book])
    func displayError(_ error: String)
}

enum SortOption {
    case title
    case author
    case year
}

class BookListPresenter {
    private weak var view: BookListViewProtocol?
    private let context: NSManagedObjectContext
    private var books: [Book] = []
    private var filteredBooks: [Book] = []
    private var currentSortOption: SortOption = .title
    
    init(view: BookListViewProtocol, context: NSManagedObjectContext) {
        self.view = view
        self.context = context
    }
    
    func fetchBooks() {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        do {
            books = try context.fetch(request)
            filteredBooks = books
            sortBooks(by: currentSortOption)
        } catch {
            view?.displayError("Failed to fetch books")
        }
    }
    
    func addBook(title: String, author: String, year: Int16) {
        let book = Book(context: context)
        book.title = title
        book.author = author
        book.year = year
        saveContext()
        fetchBooks()
    }
    
    func updateBook(_ book: Book, title: String, author: String, year: Int16) {
        book.title = title
        book.author = author
        book.year = year
        saveContext()
        fetchBooks()
    }
    
    func deleteBook(_ book: Book) {
        context.delete(book)
        saveContext()
        fetchBooks()
    }
    
    func sortBooks(by option: SortOption) {
        currentSortOption = option
        switch option {
        case .title:
            filteredBooks.sort { $0.title ?? "" < $1.title ?? "" }
        case .author:
            filteredBooks.sort { $0.author ?? "" < $1.author ?? "" }
        case .year:
            filteredBooks.sort { $0.year < $1.year }
        }
        view?.displayBooks(filteredBooks)
    }
    
    func filterBooks(with query: String) {
        if query.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { book in
                return (book.title?.lowercased().contains(query.lowercased()) ?? false) ||
                (book.author?.lowercased().contains(query.lowercased()) ?? false) ||
                ("\(book.year)".contains(query))
            }
        }
        sortBooks(by: currentSortOption)
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            view?.displayError("Failed to save context")
        }
    }
}

