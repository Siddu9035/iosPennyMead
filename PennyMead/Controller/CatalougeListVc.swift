//
//  CatalougeListVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 17/01/24.
//

import UIKit

class CatalougeListVc: UIViewController, DrawerDelegate {
    
    @IBOutlet var booksNameButton: UIButton!
    
    var selectedBook: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.shared.configureSideMenu(parentViewController: self)
        configureUI()
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(named: "gradientColor1")!, UIColor(named: "gradientColor2")!]
        gradient.frame = booksNameButton.bounds
        booksNameButton.layer.insertSublayer(gradient, at: 0)
    }
    //MARK: Drawer close
    func didPressBacbutton() {
        SideMenuManager.shared.toggleSideMenu(expanded: false)
    }
    @IBAction func onPressDrawerMenu(_ sender: Any) {
        SideMenuManager.shared.toggleSideMenu(expanded: true)
    }
    
    //MARK: firstDropdown
    func configureUI() {
        if let book = selectedBook {
            print("Received in CatalougeListVc: \(book)")
            booksNameButton.setTitle(book.name, for: .normal)
        } else {
            print("selectedBook is nil in CatalougeListVc")
        }
    }
    
    @IBAction func onPressBooksButton(_ sender: Any) {
    }
    
}
