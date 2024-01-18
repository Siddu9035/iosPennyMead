//
//  FooterView.swift
//  PennyMead
//
//  Created by siddappa tambakad on 10/01/24.
//

import UIKit

class FooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewForXib = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)! [0] as! UIView
        viewForXib.frame = self.bounds
        addSubview(viewForXib)
    }
    
}
