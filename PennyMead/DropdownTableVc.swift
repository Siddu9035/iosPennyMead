//
//  DropdownTableVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 30/01/24.
//

import UIKit

protocol DropdownDelegate: AnyObject {
    func didSelectOption(option: String)
}

class DropdownTableVc: UITableViewController {
    
    var delegate: DropdownDelegate?
    
//    @IBOutlet var dropdownTextlabel: UILabel!
    var options: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return options.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        delegate?.didSelectOption(option: options[indexPath.row])
    }
}
