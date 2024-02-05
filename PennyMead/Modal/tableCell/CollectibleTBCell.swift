//
//  CollectibleCell.swift
//  PennyMead
//
//  Created by siddappa tambakad on 07/01/24.
//

import UIKit

class CollectibleTBCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var dropdownText: UILabel!
    
    @IBOutlet var simpleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    @IBAction func onPressAddToCart(_ sender: UIButton) {
//
//    }
    
    
}
