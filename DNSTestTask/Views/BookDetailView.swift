//
//  BookDetailView.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 17.05.2024.
//

import UIKit

protocol BookDetailViewDelegate: AnyObject {
    func didTapSaveButton(title: String, author: String, year: Int)
}

class BookDetailView: UIView {
    let titleTextField = UITextField()
    let authorTextField = UITextField()
    let yearTextField = UITextField()
    let saveButton = UIButton(type: .system)
    
    weak var delegate: BookDetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        [titleTextField, authorTextField, yearTextField].forEach { textField in
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        titleTextField.placeholder = "Title"
        authorTextField.placeholder = "Author"
        yearTextField.placeholder = "Year"
        yearTextField.keyboardType = .numberPad
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        saveButton.backgroundColor = .systemYellow
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleTextField, authorTextField, yearTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text,
              let author = authorTextField.text,
              let yearString = yearTextField.text,
              let year = Int(yearString) else { return }
        
        delegate?.didTapSaveButton(title: title, author: author, year: year)
    }
}

