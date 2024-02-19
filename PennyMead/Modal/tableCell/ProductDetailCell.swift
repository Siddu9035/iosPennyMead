//
//  CollectibleCell.swift
//  PennyMead
//
//  Created by siddappa tambakad on 07/01/24.
//

import UIKit

class ProductDetailCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var cardImage: UIImageView!
    @IBOutlet var cardAuthor: UILabel!
    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardDescription: UILabel!
    @IBOutlet var cardPrice: UILabel!
    @IBOutlet var addTocartButton: UIButton!
    @IBOutlet var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.layer.shadowRadius = 4.0
        cardView.layer.masksToBounds = false // if needed
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
