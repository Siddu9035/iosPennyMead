//
//  CustomDropdown.swift
//  PennyMead
//
//  Created by siddappa tambakad on 30/01/24.
//

import UIKit
import Foundation

protocol CustomDropdownDelegate {
    func didSelectOption(option: String)
}

class CustomDropdown: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    var delegate: CustomDropdownDelegate?
    
    var options: [String] = []
    var selectedIndexPath: IndexPath?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DropdownCell")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    func hideDropdown() {
        self.isHidden = true
    }
    
    private func setupUI() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5.0
        tableView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.textColor = UIColor(named: "borderColor")
        
        if indexPath == selectedIndexPath {
            cell.contentView.backgroundColor = UIColor(named: "borderColor")
            cell.textLabel?.textColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = .clear
            cell.textLabel?.textColor = UIColor(named: "borderColor")
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath != selectedIndexPath {
            selectedIndexPath = indexPath
            delegate?.didSelectOption(option: options[indexPath.row])
            hideDropdown() // Hide the dropdown after an option is selected
        }
    }
    func reloadTableView() {
        tableView.reloadData()
    }
}
extension CustomDropdown {
    func highlightCell(at index: Int) {
        selectedIndexPath = IndexPath(row: index, section: 0)
        tableView.reloadData()
    }
}
