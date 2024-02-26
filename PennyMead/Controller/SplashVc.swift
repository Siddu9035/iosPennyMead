//
//  SplashVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 04/01/24.
//

import UIKit

class SplashVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        splashScreen()
    }
    
    func splashScreen() {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let launchScreen = storyBoard.instantiateViewController(withIdentifier: "SplashVc") as! SplashVc
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(navigateToHomeVc), userInfo: nil, repeats: false)
        
    }
    
    @objc func navigateToHomeVc() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeVc = storyBoard.instantiateViewController(withIdentifier: "HomeVc") as! HomeViewController
        navigationController?.pushViewController(homeVc, animated: true)
    }
}
