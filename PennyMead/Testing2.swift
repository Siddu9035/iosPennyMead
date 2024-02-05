//
//  Testing2.swift
//  PennyMead
//
//  Created by siddappa tambakad on 22/01/24.
//

import UIKit

class Testing2: UIViewController {
    
//    let sideMenu = SideMenuNavigationController(rootViewController: TestingViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        sideMenu.presentationStyle = .menuSlideIn
//        sideMenu.blurEffectStyle = .dark
//        sideMenu.menuWidth = view.bounds.width * 0.75
//        SideMenuManager.default.leftMenuNavigationController = sideMenu
//        SideMenuManager.default.addPanGestureToPresent(toView: view)
//        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    @IBAction func onPressMenuButton(_ sender: Any) {
//        present(sideMenu, animated: true)
    }
    
}
