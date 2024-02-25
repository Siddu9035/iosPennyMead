//
//  collectibleCvCell.swift
//  PennyMead
//
//  Created by siddappa tambakad on 09/01/24.
//

import UIKit

protocol CollectibleCvCellDelegate {
    func addToCartButtonTapped(for cell: CollectibleCvCell)
}

class CollectibleCvCell: UICollectionViewCell {
    
    @IBOutlet var cardAuthor: UILabel!
    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardDescription: UILabel!
    @IBOutlet var cardButton: UIButton!
    @IBOutlet var cardPrice: UILabel!
    @IBOutlet var cardImage1: UIImageView!
    @IBOutlet var cardView: UIView!
    
    var delegate: CollectibleCvCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 4.0
        cardView.layer.masksToBounds = false // if needed
        cardButton.layer.cornerRadius = 5
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @IBAction func onPressAddCartButton(_ sender: UIButton) {
        delegate?.addToCartButtonTapped(for: self)
    }
    
}
