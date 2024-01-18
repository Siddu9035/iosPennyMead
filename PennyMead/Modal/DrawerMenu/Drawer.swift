//
//  Drawer.swift
//  PennyMead
//
//  Created by siddappa tambakad on 16/01/24.
//

import UIKit

protocol DrawerDelegate {
    func didPressBacbutton()
}

class Drawer: UIViewController {
    
    
    @IBOutlet var lineView: UIView!
    
    var delegate: DrawerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        lineView.layer.borderWidth = 1
        lineView.layer.borderColor = UIColor(named: "CardColor")?.cgColor
        

    }
    @IBAction func onPressBackButton(_ sender: UIButton) {
        delegate?.didPressBacbutton()
    }
    
    @IBAction func onPressHomeButton(_ sender: Any) {
        if let navigationController = navigationController, let currentVc = navigationController.topViewController, currentVc is HomeVc {
            delegate?.didPressBacbutton()
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let catLouge = storyBoard.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
            navigationController?.pushViewController(catLouge, animated: true)
        }
    }
    
    @IBAction func onPressAboutUs(_ sender: Any) {
    }
    
}
