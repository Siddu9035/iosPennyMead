//
//  AboutUsVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 05/02/24.
//

import UIKit
import Kingfisher

class AboutUsVc: UIViewController, categoryManagerDelegate {
    
    @IBOutlet var collectibleCollectionView: UICollectionView!
    @IBOutlet var collectibleCollectionHeight: NSLayoutConstraint!
    
    var categories: [Book] = []
    var categoryManager = CategoryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        registerCell()
        categoryManager.delegate = self
        categoryManager.getCategories()
    }
    func registerCell() {
        collectibleCollectionView.delegate = self
        collectibleCollectionView.dataSource = self
        collectibleCollectionView.register(UINib(nibName: "CollectionVc", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectibleCollectionView.collectionViewLayout = layout
    }
    override func viewDidLayoutSubviews() {
        uppdateCollectionViewHeight()
    }
    func uppdateCollectionViewHeight() {
        self.collectibleCollectionHeight.constant = self.collectibleCollectionView.contentSize.height
    }
    func categoriesDidFetch(categories: [Book]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.collectibleCollectionView.reloadData()
            self.stopLoading()
        }
    }
    
    func didFailWithError(error: Error, response: HTTPURLResponse?) {
        DispatchQueue.main.async {
            self.stopLoading() // Assuming this is a method to hide the loading indicator
            
            if let networkError = error as? URLError, networkError.code == .notConnectedToInternet {
                // No internet connection error
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
    
}
extension AboutUsVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionVc
        let book = categories[indexPath.item]
        cell.authorName.text = book.author
        cell.title.text = book.name
        if let imageURLString = book.image?.first, let imageURL = URL(string: imageURLString) {
            cell.bookImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderimg"), options: nil) { result in
                switch result {
                case .success(_): break
                    //                        print("Image loaded: categories")
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        } else {
            cell.bookImage.image = UIImage(named: "placeholderimg")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        let cellWidth = collectionWidth * 0.5
        return CGSize(width: cellWidth, height: 320)
    }
    
}
