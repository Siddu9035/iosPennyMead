//
//  DropDownCollection.swift
//  PennyMead
//
//  Created by siddappa tambakad on 01/02/24.
//

import UIKit

protocol DropDownCollectionDelegate: AnyObject {
    func didTapButton(with title: String, forCell cell: DropDownCollection, sender: UIButton, frame: CGRect)
}

class DropDownCollection: UICollectionViewCell, CustomDropdownDelegate {
    
    var delegate: DropDownCollectionDelegate?
    
    @IBOutlet var dropdownButtons: GradientButton!
    @IBOutlet var dropdownImage: UIImageView!
    
    var dropdownView: CustomDropdown?
    var title: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDropdownView()
    }
    
    @IBAction func onPressDropdownButtons(_ sender: UIButton) {
        let frame = sender.convert(sender.bounds, to: nil)
        delegate?.didTapButton(with: title, forCell: self, sender: sender, frame: frame)
    }
    
    func setupDropdownView() {
        // Create and configure your custom dropdown view
        dropdownView = CustomDropdown(frame: CGRect(x: 0, y: dropdownButtons.frame.maxY + 5, width: dropdownButtons.frame.width, height: 200))
        dropdownView?.delegate = self
//        dropdownView?.options = ["Option 1", "Option 2", "Option 3"]
        addSubview(dropdownView!) // Add dropdownView to the superview
        
        // Set up Auto Layout constraints in the superview
        dropdownView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dropdownView!.topAnchor.constraint(equalTo: dropdownButtons.bottomAnchor, constant: 5),
            dropdownView!.leadingAnchor.constraint(equalTo: dropdownButtons.leadingAnchor),
            dropdownView!.widthAnchor.constraint(equalTo: dropdownButtons.widthAnchor),
            dropdownView!.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        dropdownView?.isHidden = true
    }
    func configure(with title: String) {
        self.title = title
        dropdownButtons.setTitle(title, for: .normal)
    }
    func didSelectOption(option: String) {
        print("selected option \(option)")
        dropdownView?.isHidden = true
    }
}
