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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onPressAddToCart(_ sender: UIButton) {
        
    }
    
    
}
