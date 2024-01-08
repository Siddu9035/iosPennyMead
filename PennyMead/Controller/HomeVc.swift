//
//  HomeVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 04/01/24.
//

import UIKit

class HomeVc: UIViewController {
    
    @IBOutlet var categoryCollection: UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var filterTable: UITableView!
    @IBOutlet var filterTableViewHeight: NSLayoutConstraint!
    //    @IBOutlet var viewForTableview: UIView!
    //    @IBOutlet var collectiblesTableView: UITableView!
    //    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    
    
    var categories: [Book] = []
    var collectiblesBooks: [Collectibles] = []
    
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
        getCategories()
        //        addImageToButton()
        
        //        viewForTableview.layer.borderWidth = 1
        
        filterTable.dataSource = self
        filterTable.delegate = self
        filterTable.isHidden = true
        filterTable.layer.borderWidth = 1
        filterTable.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        filterTable.layer.cornerRadius = 5
        filterTableViewHeight.constant = 0
        filterTable.layer.zPosition = 10
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        filterButton.layer.cornerRadius = 5
    }
    
    override func viewDidLayoutSubviews() {
        self.changeCollectionHeight()
        //        self.changeTableViewHeight()
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
                        //                        print(self.categories)
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
    //    func registerCollectibleTable() {
    //        collectiblesTableView.register(UINib(nibName: "CollectibleCell", bundle: nil), forCellReuseIdentifier: "collectibleCell")
    //    }
    
    func changeCollectionHeight() {
        self.collectionViewHeight.constant = self.categoryCollection.contentSize.height
    }
    
    //setting tableview height based on the content
    //        func changeTableViewHeight() {
    //            self.tableViewHeight.constant = self.collectiblesTableView.contentSize.height
    //        }
    
    //    func addImageToButton() {
    //        // Assuming 'yourButton' is your UIButton instance
    //        let image = UIImage(named: "Vector-Up") // Replace 'yourImageName' with the name of your image asset
    //        // Create a button configuration
    //        var config = UIButton.Configuration.plain()
    //        // Set the image for the button
    //        config.image = image
    //        config.imagePadding = 70
    //        // Set the position of the image to the trailing side of the button
    //        config.imagePlacement = .trailing
    //        // Apply the configuration to yourButton
    //        filterButton.configuration = config
    //        filterButton.layer.borderWidth = 1
    //        filterButton.layer.borderColor = UIColor(named: "borderColor")?.cgColor
    //        filterButton.layer.cornerRadius = 5
    //    }
    
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
            print("--------------")
        }
    
    //    //Mark: Collectibles
    //    func getCollectibles() {
    //        let url = URL(string: "https://stagingapi.pennymead.com/view/allCategoryData/newlyUpdated/1/")!
    //        let task = URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let data = data {
    //                do {
    //                    let collectiblesResponse = try JSONDecoder().decode(CollectibleResposnse.self, from: data)
    //                    //                    self.collectiblesBooks = collectiblesResponse.data
    //                    //                    DispatchQueue.main.async {
    //                    //                        self.collectiblesTableView.reloadData()
    //                    //                    }
    //                    print(collectiblesResponse)
    //
    //                } catch {
    //                    print("error in fetching jasonData \(error)")
    //                }
    //            } else if let error = error {
    //                print("error in fetching data \(error)")
    //            }
    //        }
    //        task.resume()
    //    }
    
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
        }
//        else if tableView == collectiblesTableView {
//            return collectiblesBooks.count
//        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == filterTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterTableCell
            let item = items[indexPath.row]
            cell.nameText.text = item.name
            return cell
//        }
//        else if tableView == collectiblesTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "collectibleCell", for: indexPath) as! CollectibleCell
//            let books = collectiblesBooks[indexPath.row]
////            cell.bookImage.image = UIImage(named: books.image)
//            cell.authorText.text = books.author
//            cell.titleText.text = books.title
//            cell.priceText.text = books.price
//            cell.bookDescription.text = books.description
//            return cell
//        }
//        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//        if tableView == filterTable {
            return 40
        }
//        else if tableView == collectiblesTableView {
//            return 400
//        }
//        return 0
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterButton.setTitle("\(items[indexPath.row].name)", for: .normal)
        animate(togle: false)
    }
}




