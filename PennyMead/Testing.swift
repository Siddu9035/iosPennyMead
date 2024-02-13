//
//  Testing.swift
//  PennyMead
//
//  Created by siddappa tambakad on 24/01/24.
//

import UIKit

class Testing: UIViewController, UITextFieldDelegate, GetSubDropdownsManagerDelegate {
    var dropdownlist: [DropdownItem] = []

    
    func didGetSubDropdowns(response: [DropdownGroup]) {
            print("------->",response)
        DispatchQueue.main.async { [self] in
            getSubDropdownsList(response: response)
        }
        
    }
    
    func didGetError(error: Error) {
        print("------->",error)

    }
    
    
    //    @IBOutlet var dropdownView: CustomDropdown!
    @IBOutlet var dropdownButton: UIButton!
    @IBOutlet var customDropdown1: CustomDropdown!
    @IBOutlet var dropdownButton2: UIButton!
    @IBOutlet var customDropdown2: CustomDropdown!
    @IBOutlet var dropdown1Height: NSLayoutConstraint!
    @IBOutlet var dropdown2Height: NSLayoutConstraint!
    @IBOutlet var dropDownImage1: UIImageView!
    //    @IBOutlet var buttonsContainerView: UIView!
    @IBOutlet var dropdown3: DropDown!
    @IBOutlet var dummyView: UIView!
    
    
    var categoryInfoArray: [(number: String, name: String)]?
    var selectedCategoryName: (name: String, category: String)?
    var scrollView: UIScrollView!
    var dropdownsManager = GetSubDropdownsManager()
    let customDropdown3 = CustomDropdown()
    
    var selectedDropDown1: String?
    var selectedDropDown2: FilterData?
    
    var optionsArray = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
    
    var filterData: [FilterData] = [
        FilterData(name: "Newest Items", type: "newlyUpdated"),
        FilterData(name: "Author", type: "author"),
        FilterData(name: "Title", type: "title"),
        FilterData(name: "Price-High", type: "price_high"),
        FilterData(name: "Price-Low", type: "price_low")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        dropdownsManager.delegate = self
        dropdownsManager.getSubDropdowns(with: "3")
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
        dropdown3.optionArray = filterData.map({$0.name})
        
        dropdown3.didSelect { (selectedText, index, id) in
            print("Selected: \(selectedText), Index: \(index), ID: \(id)")
        }
        
    }
    func getSubDropdownsList(response: [DropdownGroup]) {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .brown
        dummyView.addSubview(scrollView)
        // Configure UIScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: dummyView.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: dummyView.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: dummyView.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: dummyView.bottomAnchor, constant: 0) // Added bottom constraint to make scrollView fill the remaining space
        ])
        // Create a contentView for the UIScrollView
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .red
        scrollView.addSubview(contentView)
        // Configure contentView constraints
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor) // Content height same as scrollview height
        ])
        
        // Create and add multiple text fields to the content view
        var previousTextField: DropDown?
        for i in 0..<response.count {// Create 5 text fields, you can adjust the count as needed
            let textField = DropDown()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = response[i].name
            textField.backgroundColor = .white
            textField.optionArray = response[i].dropdownlist.map({
                $0.name
            })
            textField.listHeight = 200
            textField.isSearchEnable = false
            textField.rowHeight = 30
            contentView.addSubview(textField)
            
            dropdownlist.append(contentsOf: response[i].dropdownlist)

            // Configure text field constraints
            NSLayoutConstraint.activate([
                textField.widthAnchor.constraint(equalToConstant: 150), // Set desired width
                textField.heightAnchor.constraint(equalToConstant: 50), // Set desired height
                textField.topAnchor.constraint(equalTo: contentView.topAnchor),
                textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                textField.leadingAnchor.constraint(equalTo: previousTextField?.trailingAnchor ?? contentView.leadingAnchor, constant: 20), // Add spacing between text fields
                textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) // Center text field vertically in the content view
            ])
            
            // Update the reference to the previous text field
            previousTextField = textField
            
            textField.didSelect { (selectedText, index, id) in
                print("Selected: \(selectedText), Index: \(index), ID: \(id)")
                print("Selected reference --->",self.dropdownlist[index].reference)
            }
        }
        
        // Adjust the content size of the scroll view to fit the content view
        if let lastTextField = previousTextField {
            contentView.trailingAnchor.constraint(equalTo: lastTextField.trailingAnchor).isActive = true
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
