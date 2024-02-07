//
//  Testing.swift
//  PennyMead
//
//  Created by siddappa tambakad on 24/01/24.
//

import UIKit

class Testing: UIViewController, GetSubDropdownsManagerDelegate {
    
    
    //    @IBOutlet var dropdownView: CustomDropdown!
    @IBOutlet var dropdownButton: UIButton!
    @IBOutlet var customDropdown1: CustomDropdown!
    @IBOutlet var dropdownButton2: UIButton!
    @IBOutlet var customDropdown2: CustomDropdown!
    @IBOutlet var dropdown1Height: NSLayoutConstraint!
    @IBOutlet var dropdown2Height: NSLayoutConstraint!
    @IBOutlet var dropDownImage1: UIImageView!
    @IBOutlet var buttonsContainerView: UIView!
    
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
        dropdownsManager.delegate = self
        dropdownsManager.getSubDropdowns(with: "1")
        
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
    func createButtons(response: ResponseData) {
        // Create a UIScrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainerView.addSubview(scrollView)
        
        // Set scrollView constraints
        scrollView.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor).isActive = true
        
        // Create buttons dynamically based on the API response
        var xOffset: CGFloat = 10.0 // Initial X offset for buttons
        let buttonHeight: CGFloat = 40.0 // You can adjust the height as needed
        
        for item in response.data {
            let button = GradientButton(type: .custom)
            button.setTitle("\(item.name)", for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.frame = CGRect(x: xOffset, y: 0, width: 200, height: buttonHeight)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.startColor = UIColor(named: "gradientColor1")!
            button.endColor = UIColor(named: "gradientColor2")!
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 40)
            button.cornerRadius = 5
            // Add the button to the scrollView
            scrollView.addSubview(button)
            let chevronImage = UIImageView(image: UIImage(named: "Vector-Down"))
            chevronImage.frame = CGRect(x: button.frame.width - 40, y: button.frame.height / 2 - 10, width: 28, height: 20)
            chevronImage.contentMode = .scaleToFill
            chevronImage.tintColor = UIColor(named: "CardColor")
            button.addSubview(chevronImage)
            
            // Create a dropdown view below the button
            let dropdownView = UIView(frame: CGRect(x: 0, y: button.frame.maxY + 5, width: 200, height: 200))
            dropdownView.backgroundColor = UIColor.lightGray // Set your desired background color
            
            // Add dropdown view below the button
            scrollView.addSubview(dropdownView)
            dropdownView.isHidden = true // Initially hide dropdown
            
            // Update X offset for the next button
            xOffset += button.frame.width + 10
        }
        
        // Set the content size of the scrollView
        scrollView.contentSize = CGSize(width: xOffset, height: buttonHeight)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        print("Button tapped: \(sender.currentTitle)")
        if let dropdownView = sender.superview?.subviews.first(where: { $0 is UIView }) {
            dropdownView.isHidden = !dropdownView.isHidden
        }
    }
    func didGetSubDropdowns(response: [ResponseData]) {
        DispatchQueue.main.async {
            if let responseData = response.first { // Assuming you're expecting only one ResponseData object
                print("Received data from server:")
                print(responseData)
                
                DispatchQueue.main.async {
                    self.createButtons(response: responseData)
                }
            } else {
                print("No response data received from server")
            }
        }
    }
    func didGetError(error: Error) {
        print("Error: \(error.localizedDescription)")
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
