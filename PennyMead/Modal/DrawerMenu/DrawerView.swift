//
//  DrawerView.swift
//  PennyMead
//
//  Created by siddappa tambakad on 22/01/24.
//

import UIKit

//protocol DrawerDelegate {
////    func didPressBackButton()
//    //    func didPressHomeButton()
//    //    func didPressAboutUs()
//}

class DrawerView: UIView {
    
    @IBOutlet var textLabelText: UILabel!
    
    @IBOutlet var firstButton: UIButton!
    
    @IBOutlet var secondButton: UIButton!
    
//    var delegate: DrawerDelegate?
    
    private let xibName = "DrawerView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Load the view from the XIB file
        if let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
    @IBAction func onPressFirstButton(_ sender: Any) {
//        delegate?.didPressBackButton()
    }
    
    
    @IBAction func onPressSecondButton(_ sender: Any) {
    }
    
}
