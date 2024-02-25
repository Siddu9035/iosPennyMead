//
//  CartScreen.swift
//  PennyMead
//
//  Created by siddappa tambakad on 23/02/24.
//

import UIKit

class CartScreen: UIViewController, CollectibleItemsManagerDelegate {
    
    
    @IBOutlet var collectibleDropdown: DropDown!
    @IBOutlet var cartProducts: UITableView!
    @IBOutlet var cartProductsHeight: NSLayoutConstraint!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var emailError: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameError: UILabel!
    @IBOutlet var address1TextField: UITextField!
    @IBOutlet var address1Error: UILabel!
    @IBOutlet var address2Textfield: UITextField!
    @IBOutlet var phoneNumberTextfield: UITextField!
    @IBOutlet var phoneNumberError: UILabel!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var stateError: UILabel!
    @IBOutlet var postalTextField: UITextField!
    @IBOutlet var postalError: UILabel!
    @IBOutlet var countryDropdown: DropDown!
    @IBOutlet var countryError: UILabel!
    @IBOutlet var paymentMethodDropdown: DropDown!
    @IBOutlet var paymentMethodError: UILabel!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var checkBox1: UIButton!
    @IBOutlet var checkBox2: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var collectibleTableView: UITableView!
    @IBOutlet var collectibleTBHeight: NSLayoutConstraint!
    @IBOutlet var formView: UIView!
    
    var cartItems: [CollectibleItem] = []
    var collectibles: [Collectableitems] = []
    
    var cartManager = CollectibleItemsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        cartItems = CartManager.shared.cartItems
        cartManager.delegate = self
        cartManager.getCollectibles()
        registerTable1()
        registerTable2()
        showingEmptyCartImage()
    }
    override func viewDidLayoutSubviews() {
        cartProductsHeight.constant = cartProducts.contentSize.height
        collectibleTBHeight.constant = collectibleTableView.contentSize.height
    }
    
    func registerTable1() {
        cartProducts.delegate = self
        cartProducts.dataSource = self
        cartProducts.register(UINib(nibName: "CartCV", bundle: nil), forCellReuseIdentifier: "CartCV")
        cartProducts.estimatedRowHeight = 200
        cartProducts.rowHeight = UITableView.automaticDimension
    }
    func registerTable2() {
        collectibleTableView.delegate = self
        collectibleTableView.dataSource = self
        collectibleTableView.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier: "ProductDetailCell")
        collectibleTableView.estimatedRowHeight = 480
        collectibleTableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func onpressMenuButton(_ sender: UIButton) {
    }
    
    func didGetCollectibles(collectible: [Collectableitems]) {
        DispatchQueue.main.async {
            self.collectibles = collectible
            print(self.collectibles)
            self.collectibleTableView.reloadData()
            self.stopLoading()
        }
    }
    
    func didGetErrors(error: Error, response: HTTPURLResponse?) {
        print(error.localizedDescription)
    }
    
    func showingEmptyCartImage() {
        if cartItems.isEmpty {
            cartProducts.isHidden = true
            formView.isHidden = true
            formView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            let imageView = UIImageView()
            imageView.image = UIImage(named: "emptyCart")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            let label = UILabel()
            label.text = "Your cart is empty"
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.black
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 250),
                imageView.heightAnchor.constraint(equalToConstant: 300)
            ])
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            cartProducts.isHidden = false
            formView.isHidden = false
            cartProductsHeight.constant = cartProducts.contentSize.height
        }
        view.layoutIfNeeded()
    }
}
extension CartScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cartProducts {
            return cartItems.count
        }
        if tableView == collectibleTableView {
            return collectibles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == cartProducts {
            let products = cartItems[indexPath.row]
            let cell = cartProducts.dequeueReusableCell(withIdentifier: "CartCV", for: indexPath) as? CartCV
            cell?.cardAuthor.text = products.author
            cell?.cardDescription.text = products.description
            cell?.cardTitle.text = products.title
            cell?.cardPrice.text = "£ \(products.price)"
            if let imageUrlString = products.image.first, let imageUrl = URL(string: imageUrlString) {
                cell?.cardImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholderimg"), options: nil) { result in
                    switch result {
                    case .success(_): break
                    case .failure(let error):
                        print("Error in loading image \(error)")
                    }
                }
            }
            return cell!
        }
        if tableView == collectibleTableView {
            guard let cell = collectibleTableView.dequeueReusableCell(withIdentifier: "ProductDetailCell", for: indexPath) as? ProductDetailCell else { return UITableViewCell() }
            let data = collectibles[indexPath.row]
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
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == cartProducts {
            return 200
        }
        if tableView == collectibleTableView {
            return 480
        }
        return 0
    }
    
}
