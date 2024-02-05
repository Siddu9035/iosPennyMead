//
//  CustomDropdownCell.swift
//  PennyMead
//
//  Created by siddappa tambakad on 30/01/24.
//

import UIKit

class CustomDropdownCell: UITableViewCell {

    @IBOutlet var itemsText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
