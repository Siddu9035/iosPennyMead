//
//  DropDownCollection.swift
//  PennyMead
//
//  Created by siddappa tambakad on 01/02/24.
//

import UIKit

protocol DropDownCollectionDelegate: AnyObject {
    func didTapButton(with title: String, forCell cell: DropDownCollection, sender: UIButton)
}

class DropDownCollection: UICollectionViewCell, CustomDropdownDelegate {
    
    var delegate: DropDownCollectionDelegate?
    
    @IBOutlet var dropdownButtons: GradientButton!
    @IBOutlet var dropdownImage: UIImageView!
    @IBOutlet var dropdownView: CustomDropdown!
    
    var title: String = ""
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropdownView.isHidden = true
        dropdownView.delegate = self
        dropdownButtons.tag = 100
    }
    @IBAction func onPressDropdownButtons(_ sender: UIButton) {
        let frame = sender.frame
        delegate?.didTapButton(with: title, forCell: self, sender: sender)
        dropdownView.isHidden = false
    }
    
    func configure(with title: String) {
        self.title = title
//        self.indexPath = indexPath
        dropdownButtons.setTitle(title, for: .normal)
    }
    func didSelectOption(option: String) {
        print("selected option \(option)")
        dropdownView.isHidden = true
    }
}
