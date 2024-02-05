//
//  DrawerMenu.swift
//  PennyMead
//
//  Created by siddappa tambakad on 23/01/24.
//

import UIKit

class DrawerMenu: UIViewController {

    @IBOutlet var dropdownButton: GradientButton!
    @IBOutlet var dropdownTable: UITableView!
    
    var options = [String]()
    
    func setDropdownButtonTitle(title: String) {
        dropdownButton.setTitle(title, for: .normal)
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        registerCell()
//        commonInit()
//    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        registerCell()
//        commonInit()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        
    }
    
    func registerCell() {
        dropdownTable.delegate = self
        dropdownTable.dataSource = self
        dropdownTable.register(UINib(nibName: "CollectibleTBCell", bundle: nil), forCellReuseIdentifier: "collectibleCell")
    }
//    func commonInit() {
//        let viewForXib = Bundle.main.loadNibNamed("DrawerMenu", owner: self, options: nil)! [0] as! UIView
//        viewForXib.frame = self.bounds
//        addSubview(viewForXib)
//    }
    
}
extension DrawerMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectibleCell", for: indexPath) as! CollectibleTBCell
        cell.dropdownText.text = "Hi"
        return cell
    }
    
    
}
