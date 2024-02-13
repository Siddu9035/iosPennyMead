
import UIKit
import Kingfisher

class CatalougeListVc: UIViewController, DrawerDelegate, FetchPerticularManagerDelegate, SearchBookManagerDelegate, GetSubDropdownsManagerDelegate, UITextFieldDelegate, FilterItemsBySubCatDelegate {
    
    @IBOutlet var booksNameButton: UIButton!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var wholeCategoryButton: UIButton!
    @IBOutlet var thisCategoryButton: UIButton!
    @IBOutlet var searchByDesButton: UIButton!
    @IBOutlet var showingBookLabel: UILabel!
    @IBOutlet var showingBookDesLabel: UILabel!
    @IBOutlet var bookCollectionView: UICollectionView!
    @IBOutlet var bookCollectionHeight: NSLayoutConstraint!
    @IBOutlet var backWardButton: UIButton!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var midButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var secondLastButton: UIButton!
    @IBOutlet var lastButton: UIButton!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var errorText: UILabel!
    @IBOutlet var noDataFoundText: UILabel!
    @IBOutlet var paginationView: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var filterDropdownImage: UIImageView!
    @IBOutlet var customDropdown2: CustomDropdown!
    @IBOutlet var dropdownHeight2: NSLayoutConstraint!
    @IBOutlet var customDropdown1: CustomDropdown!
    @IBOutlet var dropdownHeight1: NSLayoutConstraint!
    @IBOutlet var firstDropdownImage: UIImageView!
    @IBOutlet var dropdownView: UIView!
    
    var perticularBooks: [PerticularItemsFetch] = []
    var perticularBookData = FetchPerticularManager()
    var searchedBooks = SearchBookManager()
    var totalPage: Int = 0
    var page: Int = 1
    var selectedIndexPath: IndexPath?
    var filterData: [FilterData] = [
        FilterData(name: "Newest Items", type: "newlyUpdated"),
        FilterData(name: "Author", type: "author"),
        FilterData(name: "Title", type: "title"),
        FilterData(name: "Price-High", type: "price_high"),
        FilterData(name: "Price-Low", type: "price_low")
    ]
    var isSearching: Bool = false
    var adesc = 0
    var selectedDropDown1: String?
    var selectedDropDown2: FilterData?
    var categoryInfoArray: [(number: String, name: String)]?
    var selectedCategoryName: (name: String, category: String)?
    var expandedCellIndex = -1
    var isCellExpanded: Bool = false
    
    let ankit = ["siddu", "mahesh"]
    var dropdownManager = GetSubDropdownsManager()
    var dropdownlist: [DropdownItem] = []
    
    var filterItems = FilterItemsBySubCat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showIndicator()
        SideMenuManager.shared.configureSideMenu(parentViewController: self)
        configureUI()
        configDropdowns()
        registerCell1()
        paginationStyles()
        configureSearchStyles()
        
        perticularBookData.delegate = self
        let selectedFilter = filterData[selectedIndexPath?.row ?? 0]
        perticularBookData.getPerticularCategories(with: selectedCategoryName?.category ?? "0", filterType: selectedFilter.type, page: page)
        searchedBooks.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        upDatePerticularBooks()
        
        dropdownManager.delegate = self
        dropdownManager.getSubDropdowns(with: selectedCategoryName?.category ?? "0")
        
        filterItems.delegate = self
        
    }
    
    func configureSearchStyles() {
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        
        wholeCategoryButton.isSelected = true
        wholeCategoryButton.setImage(UIImage(named: "radioOn"), for: .selected)
        wholeCategoryButton.setImage(UIImage(named: "radioOff"), for: .normal)
        
        thisCategoryButton.setImage(UIImage(named: "radioOn"), for: .selected)
        thisCategoryButton.setImage(UIImage(named: "radioOff"), for: .normal)
        
        searchByDesButton.setImage(UIImage(named: "check"), for: .selected)
        searchByDesButton.setImage(UIImage(named: "unCheck"), for: .normal)
    }
    //MARK: configure border, cornerRadius
    func configDropdowns() {
        customDropdown1.layer.cornerRadius = 5
        customDropdown1.addShadow()
        
        customDropdown2.layer.cornerRadius = 5
        customDropdown2.addShadow()
        
        customDropdown2.options = filterData.map { $0.name }
        
        // Set the dropdown delegate
        customDropdown1.delegate = self
        customDropdown2.delegate = self
        
        // Hide dropdown initially
        customDropdown1.isHidden = true
        customDropdown2.isHidden = true
        
        // Set initial heights of dropdowns
        dropdownHeight1.constant = 210
        dropdownHeight2.constant = 210
        
        if let categoryInfoArray = categoryInfoArray {
            // Set the button title using the selected category name
            booksNameButton.setTitle(selectedCategoryName?.name, for: .normal)
            let categoryoptions = categoryInfoArray.map{ $0.name }
            customDropdown1.options = categoryoptions
        }
        if let initialSelectedCategory = categoryInfoArray?.first(where: { $0.name == selectedCategoryName?.name }) {
            if let index = categoryInfoArray?.firstIndex(where: { $0 == initialSelectedCategory }) {
                customDropdown1.highlightCell(at: index)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        self.updateCollectionViewHeight()
    }
    //MARK: give pagination Styles
    func paginationStyles() {
        firstButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        firstButton.layer.borderWidth = 1
        firstButton.layer.cornerRadius = 5
        secondButton.layer.borderWidth = 1
        secondButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        secondButton.layer.cornerRadius = 5
        midButton.layer.borderWidth = 1
        midButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        midButton.layer.cornerRadius = 5
        secondLastButton.layer.borderWidth = 1
        secondLastButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        secondLastButton.layer.cornerRadius = 5
        lastButton.layer.borderWidth = 1
        lastButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        lastButton.layer.cornerRadius = 5
        
        backWardButton.layer.borderWidth = 1
        backWardButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        backWardButton.layer.cornerRadius = 5
        
        forwardButton.layer.borderWidth = 1
        forwardButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        forwardButton.layer.cornerRadius = 5
        
        numberTextField.layer.borderWidth = 1
        numberTextField.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        numberTextField.layer.cornerRadius = 5
        
        paginationView.layer.shadowColor = UIColor.gray.cgColor
        paginationView.layer.cornerRadius = 5
        paginationView.layer.shadowOffset = CGSize(width: 0, height: 3)
        paginationView.layer.shadowRadius = 4.0
        paginationView.layer.shadowOpacity = 0.5
        
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        filterButton.layer.cornerRadius = 5
    }
    //MARK: update the heights of the collectionview
    func updateCollectionViewHeight() {
        self.bookCollectionHeight.constant = self.bookCollectionView.contentSize.height
    }
    //MARK: registercell for the bookcollectionview
    func registerCell1() {
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        bookCollectionView.register(UINib(nibName: "CollectibleCvCell", bundle: nil), forCellWithReuseIdentifier: "cellItems")
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        bookCollectionView.collectionViewLayout = layout
    }
    //MARK: Drawer close
    func didPressBacbutton() {
        SideMenuManager.shared.toggleSideMenu(expanded: false)
    }
    //MARK: Drawer open
    @IBAction func onPressDrawerMenu(_ sender: Any) {
        SideMenuManager.shared.toggleSideMenu(expanded: true)
    }
    
    //MARK: firstDropdown
    func configureUI() {
        if let book = selectedCategoryName {
            booksNameButton.setTitle(book.name, for: .normal)
            showingBookLabel.text = book.name
        } else {
            print("selectedBook is nil in CatalougeListVc")
        }
        customDropdown2.highlightCell(at: 0)
    }
    //MARK: UPDATE Text when searching is done
    func configureText() {
        if let searchTerm = searchField.text, !searchTerm.isEmpty {
            showingBookLabel.text = "Showing results for '\(searchTerm)'"
        } else {
            booksNameButton.setTitle(selectedCategoryName?.name, for: .normal)
            showingBookLabel.text = selectedCategoryName?.name
        }
    }
    //MARK: searchCat api call
    func didUpdateThePerticularCatSearch(_ perticularCat: [PerticularItemsFetch]) {
        DispatchQueue.main.async { [self] in
            if isSearching {
                perticularBooks = perticularCat
                stopLoading()
                upDatePerticularBooks()
                configureText()
                bookCollectionView.reloadData()
            }
        }
    }
    //MARK: perticular api call
    func didUpdateThePerticularCat(_ perticularCat: [PerticularItemsFetch]) {
        DispatchQueue.main.async { [self] in
            if !isSearching {
                perticularBooks = perticularCat
                upDatePerticularBooks()
                stopLoading()
                bookCollectionView.reloadData()
            }
        }
    }
    func didRecieveDataForGetSub(response: [PerticularItemsFetch]) {
        DispatchQueue.main.async { [self] in
            perticularBooks = response
            stopLoading()
            bookCollectionView.reloadData()
        }
    }
    
    //MARK: error for both search and perticular
    func didGetErrors(error: Error) {
        DispatchQueue.main.async { [self] in
            self.stopLoading()
            
            if !isSearching {
                if let networkError = error as? URLError, networkError.code == .notConnectedToInternet {
                    showPopUp(title: "No internet connection")
                } else {
                    print("Unexpected error: \(error)")
                    showPopUp(title: "something went wrong")
                }
            } else {
                
            }
        }
    }
    //MARK: show the popup for any errors
    func showPopUp(title: String) {
        let customPop = CustomPopUp()
        customPop.networkErrorTextTitle = title
        customPop.show()
    }
    //MARK: totalPage
    func didUpdateTotalPages(_ totalPages: Int) {
        DispatchQueue.main.async {
            self.totalPage = totalPages
            print(self.totalPage)
            self.updatePaginationUi(with: self.page, totalPage: self.totalPage)
        }
    }
    //MARK: category description
    func didGetTheCatDes(_ categorydescription: [CategoryDescription]) {
        DispatchQueue.main.async { [self] in
            if let firstDescription = categorydescription.first {
                let catDescription = firstDescription.categoryDescription
                showingBookDesLabel.text = catDescription.html2String
            }
        }
    }
    //MARK: show text for no data found
    func upDatePerticularBooks() {
        if perticularBooks.isEmpty {
            noDataFoundText.text = "No Data Found"
            paginationView.isHidden = true
        } else {
            noDataFoundText.text = ""
            paginationView.isHidden = false
        }
        bookCollectionView.reloadData()
    }
    
    //MARK: func for button pagination
    func updatePaginationUi(with page: Int, totalPage: Int) {
        DispatchQueue.main.async { [self] in
            let halftotalPage = Int(round(Double(totalPage) / 2.0))
            if totalPage < 6 {
                self.totalPage = totalPage
                secondButton.isHidden = totalPage == 1 ? true : false
                midButton.isHidden = totalPage < 3 ? true : false
                secondLastButton.isHidden = totalPage < 4 ? true : false
                lastButton.isHidden = totalPage < 5 ? true : false
                firstButton.setTitle("1", for: .normal)
                secondButton.setTitle("2", for: .normal)
                midButton.setTitle("3", for: .normal)
                midButton.isEnabled = true
                secondLastButton.setTitle("4", for: .normal)
                lastButton.setTitle("5", for: .normal)
                firstButton.backgroundColor = page == 1 ? UIColor(named: "borderColor") : .clear
                firstButton.setTitleColor(page == 1 ? .white : UIColor(named: "borderColor"), for: .normal)
                secondButton.backgroundColor = page == 2 ? UIColor(named: "borderColor") : .clear
                secondButton.setTitleColor(page == 2 ? .white : UIColor(named: "borderColor"), for: .normal)
                midButton.backgroundColor = page == 3 ? UIColor(named: "borderColor") : .clear
                midButton.setTitleColor(page == 3 ? .white : UIColor(named: "borderColor"), for: .normal)
                secondLastButton.backgroundColor = page == 4 ? UIColor(named: "borderColor") : .clear
                secondLastButton.setTitleColor(page == 4 ? .white : UIColor(named: "borderColor"), for: .normal)
                lastButton.backgroundColor = page == 5 ? UIColor(named: "borderColor") : .clear
                lastButton.setTitleColor(page == 5 ? .white : UIColor(named: "borderColor"), for: .normal)
            } else if page < halftotalPage {
                // Display pages in the first half
                firstButton.setTitle("\(page)", for: .normal)
                self.page = page
                firstButton.backgroundColor = UIColor(named: "borderColor")
                firstButton.setTitleColor(.white, for: .normal)
                lastButton.backgroundColor = UIColor.clear
                secondButton.setTitle("\(page + 1)", for: .normal)
                midButton.isHidden = false
                midButton.isEnabled = false
                secondLastButton.setTitle("\(totalPage - 1)", for: .normal)
                lastButton.setTitle("\(totalPage)", for: .normal)
                lastButton.setTitleColor(UIColor(named: "borderColor"), for: .normal)
            } else {
                // Display pages in the second half
                lastButton.setTitle("\(page)", for: .normal)
                lastButton.backgroundColor = UIColor(named: "borderColor")
                lastButton.setTitleColor(.white, for: .normal)
                firstButton.backgroundColor = UIColor.clear
                firstButton.setTitleColor(UIColor(named: "borderColor"), for: .normal)
                secondLastButton.setTitle("\(page - 1)", for: .normal)
                midButton.isHidden = false
                midButton.isEnabled = false
                firstButton.setTitle("1", for: .normal)
                secondButton.setTitle("2", for: .normal)
            }
            backWardButton.isHidden = page == 1 ? true : false
            forwardButton.isHidden = page == totalPage ? true : false
        }
    }
    //MARK: Api call for the subdropdowns
    func didGetSubDropdowns(response: [DropdownGroup]) {
        DispatchQueue.main.async { [self] in
            getSubDropdownsList(response: response)
        }
    }
    
    func didGetError(error: Error) {
        print(error)
    }
    
    //MARK: adding multipledropdowns through programatically
    func getSubDropdownsList(response: [DropdownGroup]) {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        dropdownView.addSubview(scrollView)
        // Configure UIScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: dropdownView.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: dropdownView.bottomAnchor, constant: 0) // Added bottom constraint to make scrollView fill the remaining space
        ])
        // Create a contentView for the UIScrollView
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
            textField.delegate = self
            textField.attributedPlaceholder = NSAttributedString(string: "\(response[i].name)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            textField.backgroundColor = .white
            textField.optionArray = response[i].dropdownlist.map({
                $0.name
            })
            textField.checkMarkEnabled = false
            textField.listHeight = 200
            textField.isSearchEnable = false
            textField.rowHeight = 30
            textField.arrowSize = 25
            textField.cornerRadius = 5
            textField.textColor = .white
            textField.startColor = UIColor(named: "gradientColor1")!
            textField.endColor = UIColor(named: "gradientColor2")!
            contentView.addSubview(textField)
            
            dropdownlist.append(contentsOf: response[i].dropdownlist)

            // Configure text field constraints
            NSLayoutConstraint.activate([
                textField.widthAnchor.constraint(equalToConstant: 200), // Set desired width
                textField.heightAnchor.constraint(equalToConstant: 50), // Set desired height
                textField.topAnchor.constraint(equalTo: contentView.topAnchor),
                textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                textField.leadingAnchor.constraint(equalTo: previousTextField?.trailingAnchor ?? contentView.leadingAnchor, constant: 20),
            ])
            
            // Update the reference to the previous text field
            previousTextField = textField
            
            textField.didSelect { [self] (selectedText, index, id) in
//                print("Selected: \(selectedText), Index: \(index), ID: \(id)")
                print("Selected reference --->",self.dropdownlist[index].reference)
                let selectedFilter = filterData[selectedIndexPath?.row ?? 0]
                filterItems.getFilterItemsBySubCat(category: selectedCategoryName?.category ?? "0", referenceId: dropdownlist[index].reference, filterType: selectedFilter.type, page: page)
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
    
    @IBAction func onPressBooksButton(_ sender: UIButton) {
        toggleDropdown(dropdown: customDropdown1, isVisible: customDropdown1.isHidden, height: 210, dropdownImage: firstDropdownImage)
        toggleDropdown(dropdown: customDropdown2, isVisible: false, height: 0, dropdownImage: filterDropdownImage)
    }
    
    @IBAction func onPressFilterButton(_ sender: UIButton) {
        toggleDropdown(dropdown: customDropdown2, isVisible: customDropdown2.isHidden, height: 210, dropdownImage: filterDropdownImage)
        toggleDropdown(dropdown: customDropdown1, isVisible: false, height: 0, dropdownImage: firstDropdownImage)
    }
    //MARK: oppress search button
    @IBAction func onPressSearchButton(_ sender: UIButton) {
        showIndicator()
        isSearching = true
        page = 1
        if let searchTerm = searchField.text, !searchTerm.isEmpty {
            adesc = searchByDesButton.isSelected ? 1 : 0
            let categoryNumber = thisCategoryButton.isSelected ? "\(selectedCategoryName?.category ?? "0")" : "0"
            let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
            searchedBooks.searchCat(with: searchTerm, adesc: adesc, categoryNumber: Int(categoryNumber)!, sortby: selectedFilterType.type, page: page)
        } else {
            stopLoading()
            upDatePerticularBooks()
        }
    }
    @IBAction func onPressRadioButtons(_ sender: UIButton) {
        if sender == wholeCategoryButton {
            wholeCategoryButton.isSelected = true
            thisCategoryButton.isSelected = false
        } else if sender == thisCategoryButton {
            wholeCategoryButton.isSelected = false
            thisCategoryButton.isSelected = true
        } else if sender == searchByDesButton {
            searchByDesButton.isSelected = !searchByDesButton.isSelected
        }
    }
    
    @IBAction func onPressNumberButtons(_ sender: UIButton) {
        showIndicator()
        let title = sender.currentTitle
        let intValue = Int(title!) ?? 1
        print(intValue)
        let searchTerm = searchField.text
        
        if isSearching {
            if intValue != page {
                let adesc: Int = searchByDesButton.isSelected ? 1 : 0
                let categoryNumber = thisCategoryButton.isSelected ? "\(selectedCategoryName?.category ?? "0")" : "0"
                let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
                page = intValue
                searchedBooks.searchCat(with: searchTerm!, adesc: adesc, categoryNumber: Int(categoryNumber)!, sortby: selectedFilterType.type, page: intValue)
            } else {
                stopLoading()
            }
        } else {
            if intValue != page {
                let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
                page = intValue
                perticularBookData.getPerticularCategories(with: selectedCategoryName?.category ?? "1", filterType: selectedFilterType.type, page: intValue)
            } else {
                stopLoading()
            }
        }
    }
    @IBAction func onPressForwardButton(_ sender: Any) {
        showIndicator()
        if isSearching {
            if page < totalPage {
                page += 1
                let intValue = page
                page = intValue
                let adesc: Int = searchByDesButton.isSelected ? 1 : 0
                let categoryNumber = thisCategoryButton.isSelected ? "\(selectedCategoryName?.category ?? "0")" : "0"
                let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
                searchedBooks.searchCat(with: searchField.text!, adesc: adesc, categoryNumber: Int(categoryNumber)!, sortby: selectedFilterType.type, page: intValue)
            } else {
                stopLoading()
            }
        } else {
            if page < totalPage {
                page += 1
                let intValue = page
                page = intValue
                let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
                perticularBookData.getPerticularCategories(with: selectedCategoryName?.category ?? "1", filterType: selectedFilterType.type, page: intValue)
                
            } else {
                stopLoading()
            }
        }
    }
    @IBAction func onPressBackwardButton(_ sender: Any) {
        showIndicator()
        if isSearching {
            if page > 1 {
                page -= 1
                let intValue = page
                let adesc: Int = searchByDesButton.isSelected ? 1 : 0
                let categoryNumber = thisCategoryButton.isSelected ? "\(selectedCategoryName?.category ?? "0")" : "0"
                let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
                searchedBooks.searchCat(with: searchField.text!, adesc: adesc, categoryNumber: Int(categoryNumber)!, sortby: selectedFilterType.type, page: intValue)
            } else {
                stopLoading()
            }
        } else {
            if page > 1 {
                page -= 1
                let intValue = page
                let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
                perticularBookData.getPerticularCategories(with: selectedCategoryName?.category ?? "1", filterType: selectedFilterType.type, page: intValue)
                page = intValue
            } else {
                stopLoading()
            }
        }
    }
    @IBAction func onPressGoButton(_ sender: UIButton) {
        showIndicator()
        if let text = numberTextField.text, !text.isEmpty {
            if let pageNumber = Int(text), pageNumber >= 1 && pageNumber <= totalPage {
                if pageNumber != page {
                    page = pageNumber
                    let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
                    if isSearching {
                        searchedBooks.searchCat(with: searchField.text!, adesc: adesc, categoryNumber: Int(selectedCategoryName?.category ?? "0")!, sortby: selectedFilterType.type, page: pageNumber)
                    } else {
                        perticularBookData.getPerticularCategories(with: selectedCategoryName?.category ?? "1", filterType: selectedFilterType.type, page: pageNumber)
                    }
                    numberTextField.text = ""
                    errorText.text = ""
                } else {
                    errorText.text = "Entered same Page"
                    stopLoading()
                }
            } else {
                errorText.text = "Entered Valid Page"
                stopLoading()
            }
        } else {
            errorText.text = "Please Enter page No"
            stopLoading()
        }
    }
}
//MARK: COllectionView Datasource and Delegate
extension CatalougeListVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bookCollectionView {
            return perticularBooks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bookCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItems", for: indexPath) as! CollectibleCvCell
            let book = perticularBooks[indexPath.item]
            cell.cardAuthor.text = book.author
            cell.cardTitle.text = book.title
            cell.cardDescription.text = book.description
            cell.cardPrice.text = ("£ \(book.price)")
            if let imageUrlString = book.image.first, let imageUrl = URL(string: imageUrlString) {
                cell.cardImage1.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholderimg"), options: nil) { result in
                    switch result {
                    case .success(_): break
                    case .failure(let error):
                        print("Error in loading image \(error)")
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bookCollectionView {
            let collectionWidth = collectionView.frame.width
            let cellWidth = collectionWidth * 0.84
            return CGSize(width: cellWidth, height: 445)
        }
        return CGSize(width: 0, height: 0)
    }
}
//MARK: Converting html to normal string
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
//MARK: didtap for the dropdowns
extension CatalougeListVc: CustomDropdownDelegate {
    func didSelectOption(option: String) {
        showIndicator()
        if customDropdown1.isHidden == false {
            // Handle selection for customDropdown1
            if let selectedCategoryInfo = categoryInfoArray?.first(where: { $0.name == option }) {
                selectedCategoryName = (name: selectedCategoryInfo.name, category: selectedCategoryInfo.number)
                booksNameButton.setTitle(option, for: .normal)
                
                // Update the API call with the new categoryNumber
                let selectedFilterType = filterData[selectedIndexPath?.row ?? 0]
                if isSearching {
                    searchedBooks.searchCat(with: searchField.text! , adesc: adesc, categoryNumber: Int(selectedCategoryName?.category ?? "0")!, sortby: selectedFilterType.type, page: page)
                } else {
                    perticularBookData.getPerticularCategories(
                        with: selectedCategoryName?.category ?? "0",
                        filterType: selectedFilterType.type,
                        page: page
                    )
                }
                firstDropdownImage.image = UIImage(named: "Vector-Down")
                customDropdown1.isHidden = true
                customDropdown1.reloadTableView()
            }
        }  else if customDropdown2.isHidden == false {
            
            if let selectedFilter = filterData.first(where: { $0.name == option }) {
                selectedDropDown2 = selectedFilter
                filterButton.setTitle(option, for: .normal)
                
                // Use the selected book's category and selectedFilter type for the API call
                let selectedFilterType = selectedFilter.type
                
                // Check isSearching flag before making API call
                if isSearching {
                    // Handle search-related API call
                    searchedBooks.searchCat(
                        with: searchField.text!,
                        adesc: adesc,
                        categoryNumber: Int(selectedCategoryName?.category ?? "0") ?? 0,
                        sortby: selectedFilterType,
                        page: page
                    )
                } else {
                    // Handle regular API call
                    perticularBookData.getPerticularCategories(
                        with: selectedCategoryName?.category ?? "0",
                        filterType: selectedFilterType,
                        page: page
                    )
                }
                customDropdown2.isHidden = true
                filterDropdownImage.image = UIImage(named: "Vector-Down")
                customDropdown2.reloadTableView()
            }
        } else {
            stopLoading()
        }
    }
}
