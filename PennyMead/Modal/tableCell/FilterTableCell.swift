//
//  FilterTableCell.swift
//  PennyMead
//
//  Created by siddappa tambakad on 07/01/24.
//

import UIKit

class FilterTableCell: UITableViewCell {
    
    @IBOutlet var nameText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameText.textColor = UIColor(named: "borderColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
