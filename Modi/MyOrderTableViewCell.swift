//
//  MyOrderTableViewCell.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 05/06/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var FoodNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
