//
//  BookListView.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 17.05.2024.
//

import UIKit

class BookListView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)
        
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.backgroundColor = .systemBackground
    }
}

