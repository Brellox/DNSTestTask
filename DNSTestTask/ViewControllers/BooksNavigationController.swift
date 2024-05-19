//
//  BooksNavigationController.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 17.05.2024.
//

import UIKit

class BooksNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = .systemBackground
    }
    
    init() {
        let bookListViewController = BookListViewController()
        super.init(rootViewController: bookListViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

