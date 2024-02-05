//
//  CollectionVc.swift
//  PennyMead
//
//  Created by siddappa tambakad on 05/01/24.
//

import UIKit

class CollectionVc: UICollectionViewCell {
    
    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var cardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 4.0
        cardView.layer.masksToBounds = false
    }
    
}

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
    }
}
