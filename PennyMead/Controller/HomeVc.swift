//
//  HomeVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 04/01/24.
//

import UIKit

class HomeVc: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var categoryCollection: UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var filterTable: UITableView!
    @IBOutlet var filterTableViewHeight: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectible_CollectionVC: UICollectionView!
    @IBOutlet var collectibel_CollectionHeight: NSLayoutConstraint!
    
    @IBOutlet var numbersButtons: [UIButton]!
    @IBOutlet var backWardButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var numbersInputButton: UITextField!
    @IBOutlet var goButton: UIButton!
    
    var categories: [Book] = []
    var collectiblesBooks: [CollectibleItem] = []
    var page = 1
    var totalPages = 10
    
    var items: [FilterData] = [
        FilterData(name: "Newest Items", type: "newlyUpdated"),
        FilterData(name: "Author", type: "author"),
        FilterData(name: "Title", type: "title"),
        FilterData(name: "Price-High", type: "price_high"),
        FilterData(name: "Price-Low", type: "price_low")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCollectionCell()
        registerCollectionCell2()
        getCategories()
        getCollectibles(filterType: "newlyUpdated", page: page)
        
        filterTable.dataSource = self
        filterTable.delegate = self
        filterTable.isHidden = true
        filterTable.layer.borderWidth = 1
        filterTable.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        filterTable.layer.cornerRadius = 5
        filterTableViewHeight.constant = 0
        filterTable.layer.zPosition = 1
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
        
        for button in numbersButtons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(named: "borderColor")?.cgColor
            button.layer.cornerRadius = 5
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.changeCollectionHeight()
        self.changeCollectionHeight2()
    }
    
    func getCategories() {
        //create url
        let url = URL(string: "https://stagingapi.pennymead.com/view/categories/")!
        
        //create task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let categoryResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    // Access categories
                    self.categories = categoryResponse.data
                    DispatchQueue.main.async {
                        self.categoryCollection.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }
        //start the task
        task.resume()
    }
    
    
    //Mark: Collection Starts
    func registerCollectionCell() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.register(UINib(nibName: "CollectionVc", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        
        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: 180, height: categoryCollection.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        categoryCollection.collectionViewLayout = layout
    }
    
    func registerCollectionCell2() {
        collectible_CollectionVC.delegate = self
        collectible_CollectionVC.dataSource = self
        collectible_CollectionVC.register(UINib(nibName: "CollectibleCvCell", bundle: nil), forCellWithReuseIdentifier: "cellItems")
        
        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: 180, height: categoryCollection.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectible_CollectionVC.collectionViewLayout = layout
    }
    
    func changeCollectionHeight() {
        self.collectionViewHeight.constant = self.categoryCollection.contentSize.height
    }
    
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
    
    @IBAction func onPressFilterButton(_ sender: UIButton) {
        if filterTable.isHidden {
            animate(togle: true)
            filterTableViewHeight.constant = 200
        } else {
            animate(togle: false)
            filterTableViewHeight.constant = 0
        }
    }
    
    @IBAction func onPressButtons(_ sender: UIButton) {
        print(sender.currentTitle!)
        
    }
    
    
    
    //    //Mark: Collectibles
    func getCollectibles(filterType: String, page: Int) {
        let url = URL(string: "https://stagingapi.pennymead.com/view/allCategoryData/\(filterType)/\(page)/")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase // If your JSON keys use snake_case
                    let collectiblesResponse = try decoder.decode(CollectibleResponse.self, from: data)
                    let collectiblesData = collectiblesResponse.data
                    let collectibles = collectiblesData.data
                    self.collectiblesBooks = collectibles
                    
                    let totalPages = collectiblesData.totalpages
//                    print(totalPages)
                    // Access collectibles array
                    DispatchQueue.main.async {
                        self.collectible_CollectionVC.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }
        task.resume()
    }

}

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
            let cellWidth = collectionWidth * 0.47
            return CGSize(width: cellWidth, height: 320)
        } else if collectionView == collectible_CollectionVC {
            let collectionWidth = collectionView.frame.width
            let cellWidth = collectionWidth * 0.75
            return CGSize(width: cellWidth, height: 445)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoryCollection {
            return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        } else if collectionView == collectible_CollectionVC {
            return UIEdgeInsets(top: 30, left: 5, bottom: 30, right: 5)
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
                URLSession.shared.dataTask(with: imageURL) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.bookImage.image = image
                        }
                    } else {
                        // Handle error or placeholder image if needed
                        print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }.resume()
            } else {
                // Set a placeholder image or handle the case where the image URL is nil
                cell.bookImage.image = UIImage(named: "placeholderimg")
            }
            return cell
        } else if collectionView == collectible_CollectionVC {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItems", for: indexPath) as! CollectibleCvCell
            let books = collectiblesBooks[indexPath.item]
            cell2.cardAuthor.text = books.author
            cell2.cardPrice.text = books.price
            cell2.cardTitle.text = books.title
            cell2.cardDescription.text = books.description
            
            if let imageURLString = books.image.first, let imageURL = URL(string: imageURLString) {
                URLSession.shared.dataTask(with: imageURL) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell2.cardImage1.image = image
                        }
                    } else {
                        // Handle error or placeholder image if needed
                        print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }.resume()
            } else {
                // Set a placeholder image or handle the case where the image URL is nil
                cell2.cardImage1.image = UIImage(named: "placeholderimg")
            }
            
            return cell2
        }
        return UICollectionViewCell()
    }
    
}

extension HomeVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath) as! FilterTableCell
        let item = items[indexPath.row]
        cell.nameText.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilterType = items[indexPath.row]
        getCollectibles(filterType: selectedFilterType.type, page: page)
        filterButton.setTitle("\(selectedFilterType.name)", for: .normal)
        animate(togle: false)
        filterTableViewHeight.constant = 0
    }
}
