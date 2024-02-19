//
//  DropdownCV.swift
//  PennyMead
//
//  Created by siddappa tambakad on 15/02/24.
//

import UIKit

protocol DropdownCVDelegate: AnyObject {
    func dropdownDidSelectItem(_ selectedText: String, atIndex index: Int, withId id: Int, atIndexPath indexPath: IndexPath)
    
}

class DropdownCV: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet var dropdown: DropDown!
    
    var delegate: DropdownCVDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropdown.delegate = self
        dropdown.isSearchEnable = true
        dropdown.arrowColor = UIColor.MyTheme.whiteColor
        dropdown.arrowSize = 18
        dropdown.rowTextColor = UIColor.MyTheme.whiteColor
        dropdown.setPadding(left: 8)
        dropdown.setGradient(startColor: UIColor.MyTheme.brandingColorGradient, endColor: UIColor.MyTheme.brandingColor)
        dropdown.textColor = UIColor.MyTheme.whiteColor
        dropdown.didSelect(completion: { [self] selectedText, index, id in
            delegate?.dropdownDidSelectItem(selectedText, atIndex: index, withId: id, atIndexPath: indexPath!)
        })
    }
    
    
}
