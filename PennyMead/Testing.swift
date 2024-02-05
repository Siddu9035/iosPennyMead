//
//  Testing.swift
//  PennyMead
//
//  Created by siddappa tambakad on 24/01/24.
//

import UIKit

class Testing: UIViewController {
    
    //    @IBOutlet var dropdownView: CustomDropdown!
    @IBOutlet var dropdownButton: UIButton!
    @IBOutlet var customDropdown1: CustomDropdown!
    @IBOutlet var dropdownButton2: UIButton!
    @IBOutlet var customDropdown2: CustomDropdown!
    @IBOutlet var dropdown1Height: NSLayoutConstraint!
    @IBOutlet var dropdown2Height: NSLayoutConstraint!
    @IBOutlet var dropDownImage1: UIImageView!
    var categoryInfoArray: [(number: String, name: String)]?
    var selectedCategoryName: (name: String, category: String)?
    
    //    let customDropdown = CustomDropdown()
    
    var selectedDropDown1: String?
    var selectedDropDown2: FilterData?
    
    var filterData: [FilterData] = [
        FilterData(name: "Newest Items", type: "newlyUpdated"),
        FilterData(name: "Author", type: "author"),
        FilterData(name: "Title", type: "title"),
        FilterData(name: "Price-High", type: "price_high"),
        FilterData(name: "Price-Low", type: "price_low")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedCategoryName!)
        customDropdown2.options = filterData.map{ $0.name }
        
        // Set the dropdown delegate
        customDropdown1.delegate = self
        customDropdown2.delegate = self
        
        // Hide dropdown initially
        customDropdown1.isHidden = true
        customDropdown2.isHidden = true
        
        // Set initial heights of dropdowns
        dropdown1Height.constant = 200
        dropdown2Height.constant = 200
        
        if let categoryInfoArray = categoryInfoArray {
            // Set the button title using the selected category name
            dropdownButton.setTitle(selectedCategoryName?.name, for: .normal)
            let categoryoptions = categoryInfoArray.map{ $0.name }
            customDropdown1.options = categoryoptions
        }
        if let initialSelectedCategory = categoryInfoArray?.first(where: { $0.name == selectedCategoryName?.name }) {
            if let index = categoryInfoArray?.firstIndex(where: { $0 == initialSelectedCategory }) {
                customDropdown1.highlightCell(at: index)
            }
        }
        if let newestItemsFilter = filterData.first(where: { $0.name == "Newest Items" }) {
            selectedDropDown2 = newestItemsFilter
            dropdownButton2.setTitle("Newest Items", for: .normal)
            customDropdown2.isHidden = true
            customDropdown2.highlightCell(at: 0)
        }
    }
    
    func toggleDropdown(dropdown: CustomDropdown, isVisible: Bool, height: CGFloat, dropdownImage: UIImageView) {
        dropdown.isHidden = !isVisible
        dropdown.frame.size.height = isVisible ? height : 0
        dropdownImage.image = isVisible ? UIImage(named: "vector-Up") : UIImage(named: "Vector-Down")
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        toggleDropdown(dropdown: customDropdown1, isVisible: customDropdown1.isHidden, height: 200, dropdownImage: dropDownImage1)
        toggleDropdown(dropdown: customDropdown2, isVisible: false, height: 0, dropdownImage: UIImageView())
    }
    
    @IBAction func onclickDropdownButton2(_ sender: UIButton) {
        toggleDropdown(dropdown: customDropdown2, isVisible: customDropdown2.isHidden, height: 200, dropdownImage: UIImageView())
        toggleDropdown(dropdown: customDropdown1, isVisible: false, height: 0, dropdownImage: UIImageView())
    }
}
extension Testing: CustomDropdownDelegate {
    func didSelectOption(option: String) {
        print("Selected option: \(option)")
        
        if customDropdown1.isHidden == false {
            selectedDropDown1 = option
            dropdownButton.setTitle(option, for: .normal)
            customDropdown1.isHidden = true
            customDropdown1.reloadTableView()
        } else if customDropdown2.isHidden == false {
            selectedDropDown2 = filterData.first(where: {$0.name == option})
            dropdownButton2.setTitle(option, for: .normal)
            customDropdown2.isHidden = true
            customDropdown2.reloadTableView()
        }
        
        
    }
}
