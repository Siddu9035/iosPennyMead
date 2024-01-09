//
//  CollectibleCell.swift
//  PennyMead
//
//  Created by siddappa tambakad on 07/01/24.
//

import UIKit

class CollectibleTBCell: UITableViewCell {
    
    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var authorText: UILabel!
    @IBOutlet var priceText: UILabel!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var bookDescription: UILabel!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var subContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        containerView.layer.borderWidth = 1
//        subContainerView.layer.borderWidth = 1
//        priceText.layer.borderWidth = 1
//        authorText.layer.borderWidth = 1
        
        subContainerView.layer.cornerRadius = 5
        subContainerView.layer.shadowColor = UIColor.black.cgColor
        subContainerView.layer.shadowOpacity = 0.5
        subContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        subContainerView.layer.shadowRadius = 4.0
        subContainerView.layer.masksToBounds = false // if needed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onPressAddToCart(_ sender: UIButton) {
        
    }
    
    
}
