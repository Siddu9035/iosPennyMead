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
    //    @IBOutlet var viewForTableview: UIView!
    @IBOutlet var collectiblesTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    //    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    
    
    var categories: [Book] = []
    var collectiblesBooks: [CollectibleItem] = []
    
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
        registerCollectibleTable()
        getCategories()
        getCollectibles(filterType: "newlyUpdated")
        
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
    }
    
    override func viewDidLayoutSubviews() {
        self.changeCollectionHeight()
        self.changeTableViewHeight()
        self.updateScrollViewContentSize()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.frame = scrollView.bounds
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
    
    func registerCollectibleTable() {
        collectiblesTableView.register(UINib(nibName: "CollectibleTBCell", bundle: nil), forCellReuseIdentifier: "collectibleCell")
        collectiblesTableView.delegate = self
        collectiblesTableView.dataSource = self
    }
    
    func changeCollectionHeight() {
        self.collectionViewHeight.constant = self.categoryCollection.contentSize.height
    }
    
    //setting tableview height based on the content
    func changeTableViewHeight() {
        self.tableViewHeight.constant = self.collectiblesTableView.contentSize.height
    }
    
    func updateScrollViewContentSize() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.height)
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
    
    //    //Mark: Collectibles
    func getCollectibles(filterType: String) {
        let url = URL(string: "https://stagingapi.pennymead.com/view/allCategoryData/\(filterType)/1/")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase // If your JSON keys use snake_case
                    let collectiblesResponse = try decoder.decode(CollectibleResponse.self, from: data)
                    let collectiblesData = collectiblesResponse.data
                    let collectibles = collectiblesData.data
                    self.collectiblesBooks = collectibles
                    // Access collectibles array
                    DispatchQueue.main.async {
                        self.collectiblesTableView.reloadData()
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
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        let cellWidth = collectionWidth * 0.47
        return CGSize(width: cellWidth, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
    
}

extension HomeVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filterTable {
            return items.count
        } else if tableView == collectiblesTableView {
            return collectiblesBooks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filterTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath) as! FilterTableCell
            let item = items[indexPath.row]
            cell.nameText.text = item.name
            return cell
        } else if tableView == collectiblesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "collectibleCell", for: indexPath) as! CollectibleTBCell
            let books = collectiblesBooks[indexPath.row]
            cell.authorText.text = books.author
            cell.titleText.text = books.title
            cell.priceText.text = books.price
            cell.bookDescription.text = books.description
            if let imageURLString = books.image.first, let imageURL = URL(string: imageURLString) {
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
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == filterTable {
            return 40
        } else if tableView == collectiblesTableView {
            return 500
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilterType = items[indexPath.row]
        getCollectibles(filterType: selectedFilterType.type)
        filterButton.setTitle("\(selectedFilterType.name)", for: .normal)
        animate(togle: false)
        filterTableViewHeight.constant = 0
    }
}




