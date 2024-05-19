//
//  BookListViewController.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 17.05.2024.
//

import UIKit
import CoreData

class BookListViewController: UIViewController, BookListViewProtocol {
    private var presenter: BookListPresenter!
    private var dataSource: UITableViewDiffableDataSource<Int, Book>!
    private var searchController = UISearchController(searchResultsController: nil)
    
    private let bookListView = BookListView()
    
    override func loadView() {
        self.view = bookListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupSearchController()
        setupKeyboardDismissRecognizer()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        presenter = BookListPresenter(view: self, context: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchBooks()
        bookListView.tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        title = "Books"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBook)),
            UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSortMenu))
        ]
        
        navigationItem.rightBarButtonItems?.forEach { $0.tintColor = .systemYellow }
        navigationController?.navigationBar.tintColor = .systemYellow
    }
    
    private func setupTableView() {
        bookListView.tableView.delegate = self
        
        dataSource = UITableViewDiffableDataSource<Int, Book>(tableView: bookListView.tableView) { tableView, indexPath, book in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseIdentifier, for: indexPath) as! BookTableViewCell
            cell.configure(with: book)
            return cell
        }
        
        bookListView.tableView.dataSource = dataSource
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc private func addBook() {
        let detailVC = BookDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func showSortMenu() {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        alert.view.tintColor = UIColor.systemYellow
        
        alert.addAction(UIAlertAction(title: "Title", style: .default) { _ in
            self.presenter.sortBooks(by: .title)
        })
        alert.addAction(UIAlertAction(title: "Author", style: .default) { _ in
            self.presenter.sortBooks(by: .author)
        })
        alert.addAction(UIAlertAction(title: "Year", style: .default) { _ in
            self.presenter.sortBooks(by: .year)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func displayBooks(_ books: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Book>()
        snapshot.appendSections([0])
        snapshot.appendItems(books)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = BookDetailViewController(book: book)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.presenter.deleteBook(book)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension BookListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            presenter.filterBooks(with: searchText)
        }
    }
}

extension BookListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterBooks(with: searchText)
    }
}

