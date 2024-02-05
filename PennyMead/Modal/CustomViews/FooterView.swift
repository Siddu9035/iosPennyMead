//
//  FooterView.swift
//  PennyMead
//
//  Created by siddappa tambakad on 10/01/24.
//

import UIKit

class FooterView: UIView {
    
    @IBOutlet var termsAndCondition: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setUpTapGestureForLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setUpTapGestureForLabel()
    }
    
    func commonInit() {
        let viewForXib = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)! [0] as! UIView
        viewForXib.frame = self.bounds
        addSubview(viewForXib)
    }
    func setUpTapGestureForLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        termsAndCondition.isUserInteractionEnabled = true
        termsAndCondition.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        print("tapped")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let catlougeVc = storyboard.instantiateViewController(withIdentifier: "catlougePage") as? CatalougeListVc {
//
//            // If you are using a navigation controller, push the view controller
//            if let navigationController = self.window?.rootViewController as? UINavigationController {
//                navigationController.pushViewController(catlougeVc, animated: true)
//            }
//            // If you are presenting modally
//            else {
//                self.window?.rootViewController?.present(catlougeVc, animated: true, completion: nil)
//            }
//        }
    }
    
}
