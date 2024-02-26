//
//  ProductDetailVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 16/02/24.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController, ProductDetailManagerDelegate, DrawerDelegate, UITextFieldDelegate, GetSubDropdownsManagerDelegate {
    
    //MARK: outlets
    @IBOutlet var firstDropdown: DropDown!
    @IBOutlet var multipleDropdown: UICollectionView!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var wholeCatalouge: UIButton!
    @IBOutlet var thisCategory: UIButton!
    @IBOutlet var searchByDescription: UIButton!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var backWardButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceText: UILabel!
    @IBOutlet var authorText: UILabel!
    @IBOutlet var descriptionText: UILabel!
    @IBOutlet var addCartButton: UIButton!
    @IBOutlet var viewAllButton: UIButton!
    @IBOutlet var relatedItemsTV: UITableView!
    @IBOutlet var relatedItemsTvHeight: NSLayoutConstraint!
    //MARK: Variables
    var productDetail: Productdetail?
    var relatedItems: [Productdetail] = []
    var productDetailManager = ProductDetailManager()
    var selectedSysid: (sysid: String, category: String)?
    var categoryInfoArray: [(number: String, name: String)]?
    var selectedCategoryName: (name: String, category: String)?
    var selectedCategoryIndex: Int?
    var filterItems = FilterItemsBySubCat()
    var dropdownManager = GetSubDropdownsManager()
    var currentImageIndex = 0
    var dropdownData: [DropdownGroup] = []
    var selectedReference: String?
    var selectedSubDropdownIndex: Int?
    var adesc: Int = 0
    var searchTerm: String = ""
    var isMainCategoryLastApiCalled: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        productDetailManager.delegate = self
        productDetailManager.getProductDetail(sysid: selectedSysid!.sysid)
        registerTableView()
        registerCell2()
        configureSearchStyles()
        firstdropDown()
        dropdownManager.delegate = self
        dropdownManager.getSubDropdowns(with: selectedCategoryName!.category)
        print("productDetail", selectedCategoryName?.category)
    }
    override func viewDidLayoutSubviews() {
        relatedItemsTvHeight.constant = relatedItemsTV.contentSize.height
    }
    override func viewWillAppear(_ animated: Bool) {
        SideMenuManager.shared.configureSideMenu(parentViewController: self)
        SideMenuManager.shared.sideMenuVc.delegate = self
    }
    func configureSearchStyles() {
        forwardButton.layer.borderWidth = 1
        forwardButton.layer.borderColor = UIColor.MyTheme.brandingColor.cgColor
        backWardButton.layer.borderWidth = 1
        backWardButton.layer.borderColor = UIColor.MyTheme.brandingColor.cgColor
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor.MyTheme.brandingColor.cgColor
        
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.MyTheme.brandingColor.cgColor
        
        wholeCatalouge.isSelected = true
        wholeCatalouge.setImage(UIImage(named: "radioOn"), for: .selected)
        wholeCatalouge.setImage(UIImage(named: "radioOff"), for: .normal)
        
        thisCategory.setImage(UIImage(named: "radioOn"), for: .selected)
        thisCategory.setImage(UIImage(named: "radioOff"), for: .normal)
        
        searchByDescription.setImage(UIImage(named: "check"), for: .selected)
        searchByDescription.setImage(UIImage(named: "unCheck"), for: .normal)
    }
    func registerTableView() {
        relatedItemsTV.delegate = self
        relatedItemsTV.dataSource = self
        relatedItemsTV.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier: "ProductDetailCell")
        relatedItemsTV.estimatedRowHeight = 480
        relatedItemsTV.rowHeight = UITableView.automaticDimension
    }
    func registerCell2() {
        multipleDropdown.delegate = self
        multipleDropdown.dataSource = self
        multipleDropdown.register(UINib(nibName: "DropdownCV", bundle: nil), forCellWithReuseIdentifier: "DropdownCV")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.multipleDropdown.collectionViewLayout = layout
    }
    func didGetSubDropdowns(response: [DropdownGroup]) {
        DispatchQueue.main.async { [self] in
            dropdownData = response
            multipleDropdown.reloadData()
        }
    }
    func didRecieveProductDetail(productDetail: Productdetail, relatedItems: [Productdetail]) {
        DispatchQueue.main.async {
            self.productDetail = productDetail
            self.relatedItems = relatedItems
            self.showProducts()
            self.relatedItemsTV.reloadData()
            self.stopLoading()
            self.view.layoutIfNeeded()
        }
    }
    
    func didGetErrors(error: Error, response: HTTPURLResponse?) {
        print(error.localizedDescription)
    }
    
    func didPressBacbutton() {
        SideMenuManager.shared.toggleSideMenu(expanded: false)
    }
    
    func showProducts() {
        if let product = productDetail {
            titleLabel.text = product.title
            authorText.text = product.author
            priceText.text = "£ \(product.price)"
            descriptionText.text = product.description
            updateButtonState()
            if let firstImageUrlString = product.image.first, let firstImageUrl = URL(string: firstImageUrlString) {
                productImage.kf.setImage(with: firstImageUrl)
            }
        }
    }
    
    func firstdropDown() {
        firstDropdown.delegate = self
        firstDropdown.setPadding(left: 10)
        if let selectedCategoryName = selectedCategoryName,
           let categoryInfoArray = categoryInfoArray {
            // Find the index of the selected category in the categoryInfoArray
            if let categoryIndex = categoryInfoArray.firstIndex(where: { $0.name == selectedCategoryName.name }) {
                firstDropdown.attributedPlaceholder = NSAttributedString(string: selectedCategoryName.name, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
                let categoryOptions = categoryInfoArray.map { $0.name }
                firstDropdown.optionArray = categoryOptions
                firstDropdown.selectedIndex = categoryIndex
                
                // Configure didSelect closure
                firstDropdown.didSelect { [self] selectedText, index, id in
                    // Retrieve selected category number and name from categoryInfoArray
                    let selectedCategoryNumber = categoryInfoArray[index].number
                    let selectedCategoryName = categoryInfoArray[index].name
                    let bothCatAndName = (name: selectedCategoryName, category: selectedCategoryNumber)
                    if let storyBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "catlougePage") as? CatalougeListViewController {
                        storyBoard.selectedCategoryName = bothCatAndName
                        storyBoard.categoryInfoArray = categoryInfoArray
                        storyBoard.selectedCategoryIndex = index
                        navigationController?.pushViewController(storyBoard, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func onPressMenuButton(_ sender: UIButton) {
        SideMenuManager.shared.toggleSideMenu(expanded: true)
    }
    
    @IBAction func onPressSearchButton(_ sender: UIButton) {
        adesc = searchByDescription.isSelected ? 1 : 0
        let categoryNumber = thisCategory.isSelected ? selectedCategoryName?.category : "0"
        let categoryName = selectedCategoryName?.name ?? ""
        let catNumber = selectedCategoryName?.category ?? "0"
        let catNumAndCat = (name: categoryName, category: catNumber)
        let categoryIndex = Int(selectedCategoryName!.category)!
        searchTerm = searchField.text ?? ""
        if let catlougeListVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "catlougePage") as? CatalougeListViewController {
            catlougeListVc.selectedCategoryName = catNumAndCat
            catlougeListVc.selectedCategoryIndex = categoryIndex
            catlougeListVc.categoryInfoArray = categoryInfoArray
            catlougeListVc.searchTerm = searchTerm
            catlougeListVc.isMainCategoryLastApiCalled = false
            catlougeListVc.isdropdownapicalled = false
            catlougeListVc.selectedCategoryNumberForSearch = categoryNumber
            catlougeListVc.adesc = adesc
            navigationController?.pushViewController(catlougeListVc, animated: true)
        }
    }
    
    @IBAction func onPressRadioButtons(_ sender: UIButton) {
        if sender == wholeCatalouge {
            wholeCatalouge.isSelected = true
            thisCategory.isSelected = false
        } else if sender == thisCategory {
            wholeCatalouge.isSelected = false
            thisCategory.isSelected = true
        } else if sender == searchByDescription {
            searchByDescription.isSelected = !searchByDescription.isSelected
        }
    }
    
    @IBAction func onPressBackwardButton(_ sender: UIButton) {
        guard let productDetail = productDetail else { return }
        guard productDetail.image.count > 0 else { return }
        
        currentImageIndex -= 1
        if currentImageIndex < 0 {
            currentImageIndex = productDetail.image.count - 1
        }
        
        showCurrentImage()
        updateButtonState()
    }
    
    @IBAction func onPressForwardButton(_ sender: UIButton) {
        guard let productDetail = productDetail else { return }
        guard productDetail.image.count > 0 else { return }
        
        currentImageIndex += 1
        if currentImageIndex >= productDetail.image.count {
            currentImageIndex = 0
        }
        
        showCurrentImage()
        updateButtonState()
    }
    func showCurrentImage() {
        guard let productDetail = productDetail else { return }
        let imageUrlString = productDetail.image[currentImageIndex]
        guard let imageUrl = URL(string: imageUrlString) else { return }
        productImage.kf.setImage(with: imageUrl)
    }
    func updateButtonState() {
        guard let productDetail = productDetail else { return }
        let isSingleImage = productDetail.image.count <= 1
        forwardButton.alpha = isSingleImage ? 0.5 : (currentImageIndex == productDetail.image.count - 1 ? 0.5 : 1.0)
        forwardButton.isEnabled = !isSingleImage && currentImageIndex < productDetail.image.count - 1
        backWardButton.alpha = isSingleImage ? 0.5 : (currentImageIndex == 0 ? 0.5 : 1.0)
        backWardButton.isEnabled = !isSingleImage && currentImageIndex > 0
    }
    
    @IBAction func onPressAddToCartButton(_ sender: UIButton) {
    }
    
    @IBAction func onPressViewAllButton(_ sender: UIButton) {
    }
}
extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DropdownCVDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dropdownData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DropdownCV", for: indexPath) as! DropdownCV
        cell.dropdown.optionArray = dropdownData[indexPath.row].dropdownlist.map({$0.name})
        cell.dropdown.text = dropdownData[indexPath.row].name
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    func dropdownDidSelectItem(_ selectedText: String, atIndex index: Int, withId id: Int, atIndexPath indexPath: IndexPath, selectedItem item: UICollectionView) {
        let categoryIndex = Int(selectedCategoryName!.category)!
        let data = dropdownData[indexPath.item].dropdownlist[index]
       if let catlougeVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "catlougePage") as? CatalougeListViewController {
           catlougeVc.selectedCategoryName = selectedCategoryName
           catlougeVc.categoryInfoArray = categoryInfoArray
           catlougeVc.selectedCategoryIndex = categoryIndex
           catlougeVc.selectedReference = data.reference
           catlougeVc.isdropdownapicalled = true
           catlougeVc.isMainCategoryLastApiCalled = false
           navigationController?.pushViewController(catlougeVc, animated: true)
        }
    }
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = relatedItemsTV.dequeueReusableCell(withIdentifier: "ProductDetailCell", for: indexPath) as? ProductDetailCell else { return UITableViewCell() }
        let data = relatedItems[indexPath.row]
        cell.cardAuthor.text = data.author
        cell.cardTitle.text = data.title
        cell.cardDescription.text = data.description
        cell.cardPrice.text = "£ \(data.price)"
        if let imageUrlString = data.image.first, let imageUrl = URL(string: imageUrlString) {
            cell.cardImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholderimg"), options: nil) { result in
                switch result {
                case .success(_): break
                case .failure(let error):
                    print("Error in loading image \(error)")
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
}
