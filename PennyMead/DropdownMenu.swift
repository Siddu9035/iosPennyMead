//
//  DropdownMenu.swift
//  PennyMead
//
//  Created by siddappa tambakad on 23/01/24.
//

import UIKit

protocol DropdownMenuDelegate: AnyObject {
    func didSelectOption(_ option: String)
}

class DropdownMenu: UIView {
    weak var delegate: DropdownMenuDelegate?
    
    private let options: [String]
    private var isMenuOpen = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(options: [String]) {
        self.options = options
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Additional setup based on your design preferences
        tableView.isHidden = true
    }
    
    func toggleMenu() {
        isMenuOpen.toggle()
        tableView.isHidden = !isMenuOpen
    }
}

extension DropdownMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = options[indexPath.row]
        delegate?.didSelectOption(selectedOption)
        toggleMenu()
    }
}


