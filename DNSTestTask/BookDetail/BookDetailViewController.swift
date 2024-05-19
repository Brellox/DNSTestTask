//
//  BookDetailViewController.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 17.05.2024.
//

import UIKit
import CoreData

class BookDetailViewController: UIViewController, BookDetailViewProtocol {
    private var presenter: BookDetailPresenter!
    private let bookDetailView = BookDetailView()
    private var book: Book?
    
    init(book: Book? = nil) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = bookDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        bookDetailView.delegate = self
        setupKeyboardDismissRecognizer()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        presenter = BookDetailPresenter(view: self, context: context, book: book)
        presenter.viewDidLoad()
    }
    
    func displayBook(_ book: Book) {
        bookDetailView.titleTextField.text = book.title
        bookDetailView.authorTextField.text = book.author
        bookDetailView.yearTextField.text = String(book.year)
        
        bookDetailView.saveButton.setTitle("Edit", for: .normal)
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension BookDetailViewController: BookDetailViewDelegate {
    func didTapSaveButton(title: String, author: String, year: Int) {
        presenter.saveBook(title: title, author: author, year: Int16(year))
    }
}

