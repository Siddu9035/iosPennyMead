//
//  HomeVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 04/01/24.
//

import UIKit
import Kingfisher

class HomeVc: UIViewController, UIScrollViewDelegate, categoryManagerDelegate, collectibleManagerDelegate, DrawerDelegate {
   
    func didGoToHomeVc() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var categoryCollection: UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var filterTable: UITableView!
    @IBOutlet var filterTableViewHeight: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectible_CollectionVC: UICollectionView!
    @IBOutlet var collectibel_CollectionHeight: NSLayoutConstraint!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var midButton: UIButton!
    @IBOutlet var secondLastButton: UIButton!
    @IBOutlet var lastButton: UIButton!
    @IBOutlet var backWardButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var numbersInputButton: UITextField!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var dropdownimage: UIImageView!
    @IBOutlet var paginationCardView: UIView!
    @IBOutlet var errorText: UILabel!
    @IBOutlet var addToCartButton: UIButton!
    
    
    var categories: [Book] = []
    var collectiblesBooks: [CollectibleItem] = []
    var page = 1
    var totalPage: Int = 0
    var selectedIndexPath: IndexPath?
    
    var categoryManager = CategoryManager()
    var collectibleManager = CollectiblesManager()
    
    var items: [FilterData] = [
        FilterData(name: "Newest Items", type: "newlyUpdated"),
        FilterData(name: "Author", type: "author"),
        FilterData(name: "Title", type: "title"),
        FilterData(name: "Price-High", type: "price_high"),
        FilterData(name: "Price-Low", type: "price_low")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showIndicator()
        
        registerCollectionCell()
        registerCollectionCell2()
        
        categoryManager.delegate = self
        self.categoryManager.getCategories()
        
        collectibleManager.delegate = self
        let selectedFilter = items[selectedIndexPath?.row ?? 0]
        collectibleManager.getCollectibles(with: selectedFilter.type, page: page)
        
        filterTable.dataSource = self
        filterTable.delegate = self
        filterTable.isHidden = true
        filterTable.layer.borderWidth = 1
        filterTable.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        filterTable.layer.cornerRadius = 5
        filterTableViewHeight.constant = 0
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        filterButton.layer.cornerRadius = 5
        
        scrollView.delegate = self
        
        backWardButton.layer.borderWidth = 1
        backWardButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        backWardButton.layer.cornerRadius = 5
        
        forwardButton.layer.borderWidth = 1
        forwardButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        forwardButton.layer.cornerRadius = 5
        
        paginationCardView.layer.shadowColor = UIColor.gray.cgColor
        paginationCardView.layer.cornerRadius = 5
        paginationCardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        paginationCardView.layer.shadowRadius = 4.0
        paginationCardView.layer.shadowOpacity = 0.5
        
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
        
        numbersInputButton.layer.borderWidth = 1
        numbersInputButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        numbersInputButton.layer.cornerRadius = 5
        
        dropdownimage.image = UIImage(named: "Vector-Down")
        
        let defaultIndexPath = IndexPath(row: 0, section: 0)
        filterTable.selectRow(at: defaultIndexPath, animated: false, scrollPosition: .none)
        selectedIndexPath = defaultIndexPath
        let selectedFilterType = items[defaultIndexPath.row]
        collectibleManager.getCollectibles(with: selectedFilterType.type, page: page)
        
        
        hideKeyboardWhenTappedAround()
    }
    override func viewDidLayoutSubviews() {
        self.changeCollectionHeight()
        self.changeCollectionHeight2()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SideMenuManager.shared.configureSideMenu(parentViewController: self)
        SideMenuManager.shared.sideMenuVc.delegate = self
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    //MARK: Category Collection
    func categoriesDidFetch(categories: [Book]) {
        DispatchQueue.main.async {
            self.categories.append(contentsOf: categories)
            self.stopLoading()
            self.categoryCollection.reloadData()
        }
    }
    func didFailWithError(error: Error, response: HTTPURLResponse?) {
        DispatchQueue.main.async {
            self.stopLoading() // Assuming this is a method to hide the loading indicator
            
            if let networkError = error as? URLError, networkError.code == .notConnectedToInternet {
                // No internet connection error
                self.showCustomPopup(title: "No Internet Connection")
            } else if let httpResponse = response, httpResponse.statusCode == 404 {
                print(httpResponse.statusCode)
            } else {
                self.showCustomPopup(title: "Error")
            }
        }
    }
    //MARK: collectible Api Call
    func didUpdateTheCollectibles(_ collectibles: [CollectibleItem]) {
        DispatchQueue.main.async {
            self.collectiblesBooks = collectibles
            self.collectible_CollectionVC.reloadData()
            self.filterTable.reloadData()
            
            self.stopLoading()
        }
    }
    func didGetError(error: Error, response: HTTPURLResponse?) {
        DispatchQueue.main.async {
            self.stopLoading()
            if let networkError = error as? URLError, networkError.code == .notConnectedToInternet {
                self.showCustomPopup(title: "No Internet Connection")
            } else {
                // Other errors
                self.showCustomPopup(title: "Error")
            }
        }
    }
    func showCustomPopup(title: String) {
        let customPop = CustomPopUp()
        customPop.networkErrorTextTitle = title
        customPop.show()
    }
    func didUpdateTotalPages(_ totalPages: Int) {
        totalPage = totalPages
        updatePaginationUi(with: page, totalPage: totalPage)
    }
    
    //MARK: Category Collection cell registration
    func registerCollectionCell() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.register(UINib(nibName: "CollectionVc", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        categoryCollection.collectionViewLayout = layout
    }
    
    //MARK: collectible collection cell registration
    func registerCollectionCell2() {
        collectible_CollectionVC.delegate = self
        collectible_CollectionVC.dataSource = self
        collectible_CollectionVC.register(UINib(nibName: "CollectibleCvCell", bundle: nil), forCellWithReuseIdentifier: "cellItems")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectible_CollectionVC.collectionViewLayout = layout
    }
    
    //MARK: category collection increase height
    func changeCollectionHeight() {
        self.collectionViewHeight.constant = self.categoryCollection.contentSize.height
    }
    
    //MARK: collectible collection increase height
    func changeCollectionHeight2() {
        self.collectibel_CollectionHeight.constant = self.collectible_CollectionVC.contentSize.height
    }
    
    //function for the toggle of dropdown
    func animate(togle: Bool) {
        if togle {
            UIView.animate(withDuration: 0.3, delay: 0.1) {
                self.filterTable.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.1) {
                self.filterTable.isHidden = true
            }
        }
    }
    //MARK: drawer close
    func didPressBacbutton() {
        SideMenuManager.shared.toggleSideMenu(expanded: false)
    }
    
    @IBAction func onPressMenuButton(_ sender: Any) {
        SideMenuManager.shared.toggleSideMenu(expanded: true)
    }
    
    @IBAction func onPressFilterButton(_ sender: UIButton) {
        if filterTable.isHidden {
            animate(togle: true)
            filterTableViewHeight.constant = 200
            dropdownimage.image = UIImage(named: "vector-Up")
        } else {
            animate(togle: false)
            filterTableViewHeight.constant = 0
            dropdownimage.image = UIImage(named: "Vector-Down")
        }
    }
    
    func handleScrollTo() {
        let bottomOfCategoryCollection = CGPoint(x: 0, y: categoryCollection.contentSize.height)
        scrollView.setContentOffset(bottomOfCategoryCollection, animated: false)
    }
    
    //MARK: func for button pagination
    func updatePaginationUi(with page: Int, totalPage: Int) {
        
        DispatchQueue.main.async { [self] in
            let halftotalPage = Int(round(Double(totalPage) / 2.0))
            if totalPage < 6 {
                secondButton.isHidden = totalPage == 1 ? true : false
                midButton.isHidden = totalPage < 3 ? true : false
                secondLastButton.isHidden = totalPage < 4 ? true : false
                lastButton.isHidden = totalPage < 5 ? true : false
                firstButton.setTitle("1", for: .normal)
                secondButton.setTitle("2", for: .normal)
                midButton.setTitle("3", for: .normal)
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
                firstButton.setTitle("1", for: .normal)
                secondButton.setTitle("2", for: .normal)
            }
            backWardButton.isHidden = page == 1 ? true : false
            forwardButton.isHidden = page == totalPage ? true : false
        }
        
    }
    
    //MARK: Button Pagination Starts
    @IBAction func onPressButtons(_ sender: UIButton) {
        
        showIndicator()
        let title = sender.currentTitle
        let intValue = Int(title!) ?? 1
        
        if intValue != page {
            let selectedFilterType = items[selectedIndexPath?.row ?? 0]
            page = intValue
            handleScrollTo()
            collectibleManager.getCollectibles(with: selectedFilterType.type, page: intValue)
            errorText.text = ""
            numbersInputButton.text = ""
        } else {
            stopLoading()
            handleScrollTo()
            errorText.text = ""
            numbersInputButton.text = ""
        }
    }
    
    //MARK: backward button pressed
    @IBAction func onPressBackwardButton(_ sender: UIButton) {
        showIndicator()
        if page > 1 {
            page -= 1
            let intValue = page
            handleScrollTo()
            let selectedFilterType = items[selectedIndexPath?.row ?? 0]
            collectibleManager.getCollectibles(with: selectedFilterType.type, page: intValue)
            page = intValue
            errorText.text = ""
            numbersInputButton.text = ""
        }
    }
    //MARK: forward button pressed
    @IBAction func onPressForwardButton(_ sender: UIButton) {
        showIndicator()
        
        if page < totalPage {
            page += 1
            let intValue = page
            handleScrollTo()
            let selectedFilterType = items[selectedIndexPath?.row ?? 0]
            collectibleManager.getCollectibles(with: selectedFilterType.type, page: intValue)
            page = intValue
            errorText.text = ""
            numbersInputButton.text = ""
        }
    }
    @IBAction func onPressGoButton(_ sender: UIButton) {
        showIndicator()
        if let text = numbersInputButton.text, !text.isEmpty {
            if let pageNumber = Int(text), pageNumber >= 1 && pageNumber <= totalPage {
                if pageNumber != page {
                    page = pageNumber
                    handleScrollTo()
                    let selectedFilterType = items[selectedIndexPath?.row ?? 0]
                    collectibleManager.getCollectibles(with: selectedFilterType.type, page: page)
                    numbersInputButton.text = ""
                    errorText.text = ""
                } else {
//                    errorText.text = "Entered same Page"
                    numbersInputButton.text = ""
                    stopLoading()
                    handleScrollTo()
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

//MARK: extension for the collectionView
extension HomeVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCollection {
            return categories.count
        } else if collectionView == collectible_CollectionVC {
            return collectiblesBooks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollection {
            let collectionWidth = collectionView.frame.width
            let cellWidth = collectionWidth * 0.5
            return CGSize(width: cellWidth, height: 320)
        } else if collectionView == collectible_CollectionVC {
            let collectionWidth = collectionView.frame.width
            let cellWidth = collectionWidth * 0.8
            return CGSize(width: cellWidth, height: 445)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoryCollection {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else if collectionView == collectible_CollectionVC {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionVc
            let book = categories[indexPath.item]
            cell.authorName.text = book.author
            cell.title.text = book.name
            if let imageURLString = book.image?.first, let imageURL = URL(string: imageURLString) {
                cell.bookImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderimg"), options: nil) { result in
                    switch result {
                    case .success(_): break
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            } else {
                cell.bookImage.image = UIImage(named: "placeholderimg")
            }
            return cell
        } else if collectionView == collectible_CollectionVC {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItems", for: indexPath) as! CollectibleCvCell
            let books = collectiblesBooks[indexPath.item]
            cell2.cardAuthor.text = books.author
            cell2.cardPrice.text = ("£ \(books.price)")
            cell2.cardTitle.text = books.title
            cell2.cardDescription.text = books.description
            if let imageURLString = books.image.first, let imageURL = URL(string: imageURLString) {
                cell2.cardImage1.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderimg"), options: nil) { result in
                    switch result {
                    case .success(_): break
                        //                        print("Image loaded: collectibles")
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            } else {
                cell2.cardImage1.image = UIImage(named: "placeholderimg")
            }
            return cell2
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollection {
            let data = categories[indexPath.item]
            selectedData(with: data, at: indexPath.item )
        }
    }
    
    func selectedData(with category: Book, at index: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let catalougePage = storyBoard.instantiateViewController(withIdentifier: "catlougePage") as? CatalougeListVc {
            let categoryInfo = categories.map{(number: $0.category, name: $0.name)}
            catalougePage.categoryInfoArray = categoryInfo
            catalougePage.selectedCategoryName = (name: category.name, category: category.category)
            catalougePage.selectedCategoryIndex = index
            catalougePage.selectedFirstDropdownIndex = index
            navigationController?.pushViewController(catalougePage, animated: true)
        }
    }
    
}
//MARK: extension for the tableview
extension HomeVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath) as! FilterTableCell
        let item = items[indexPath.row]
        cell.nameText.text = item.name
        if indexPath == selectedIndexPath {
            cell.contentView.backgroundColor = UIColor(named: "borderColor")
            cell.nameText.textColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = UIColor.white
            cell.nameText.textColor = UIColor(named: "borderColor")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showIndicator()
        let selectedFilterType = items[indexPath.row]
        filterButton.setTitle("\(selectedFilterType.name)", for: .normal)
        dropdownimage.image = UIImage(named: "Vector-Down")
        animate(togle: false)
        filterTable.isHidden = true
        
        if indexPath != selectedIndexPath {
            selectedIndexPath = indexPath
            let selectedFilterType = items[indexPath.row]
            collectibleManager.getCollectibles(with: selectedFilterType.type, page: page)
        } else {
            stopLoading()
        }
    }
}

