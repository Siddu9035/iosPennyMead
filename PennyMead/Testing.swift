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
    //    @IBOutlet var buttonsContainerView: UIView!
    
    @IBOutlet var testView: UIView!
    
    var categoryInfoArray: [(number: String, name: String)]?
    var selectedCategoryName: (name: String, category: String)?
    var scrollView: UIScrollView!
    var dropdownsManager = GetSubDropdownsManager()
    let customDropdown3 = CustomDropdown()
    
    var selectedDropDown1: String?
    var selectedDropDown2: FilterData?
    
    var filterData: [FilterData] = [
        FilterData(name: "Newest Items", type: "newlyUpdated"),
        FilterData(name: "Author", type: "author"),
        FilterData(name: "Title", type: "title"),
        FilterData(name: "Price-High", type: "price_high"),
        FilterData(name: "Price-Low", type: "price_low")
    ]
    
    let dummyArray = ["US": "United States",
                      "BE": "Belgium",
                      "CN": "China",
                      "CN1": "China",
                      "CN2": "China",
                      "CN3": "China",
                      "CN4": "China"]
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let numberOfViews = 10 // Set the number of views you want to render
        
        // Create a UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Configure UIScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            scrollView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Create a horizontal UIStackView
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10 // Set spacing between views
        stackView.alignment = .center // Align views in the center horizontally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the stack view to the scroll view
        scrollView.addSubview(stackView)
        
        // Configure stack view constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        for index in 0..<numberOfViews {
            // Instantiate UIButton
            let button = UIButton(type: .system)
            
            // Configure UIButton
            button.setTitle("Button \(index + 1)", for: .normal)
            button.backgroundColor = UIColor.blue
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true // Set button width
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true // Set button height
            button.layer.cornerRadius = 8
            
            // Add UIButton to the stack view
            stackView.addArrangedSubview(button)
            
            // Instantiate UIView
            let newView = UIView()
            
            // Configure UIView
            newView.backgroundColor = UIColor.red
            newView.widthAnchor.constraint(equalToConstant: 100).isActive = true // Set view width
            newView.heightAnchor.constraint(equalToConstant: 40).isActive = true // Set view height
            newView.layer.cornerRadius = 8
            
            // Add UIView to the stack view
            stackView.addArrangedSubview(newView)
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
