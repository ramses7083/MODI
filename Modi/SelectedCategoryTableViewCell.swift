//
//  SelectedCategoryTableViewCell.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 18/09/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class SelectedCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var FoodLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
