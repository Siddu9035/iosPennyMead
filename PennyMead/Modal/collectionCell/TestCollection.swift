//
//  TestCollection.swift
//  PennyMead
//
//  Created by siddappa tambakad on 23/01/24.
//

import UIKit

class TestCollection: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var dropdownHeader: UIButton!
    @IBOutlet var dropdown: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func onPressTestButton(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropdown", for: indexPath)
        cell.textLabel?.text = "Hi"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

}
