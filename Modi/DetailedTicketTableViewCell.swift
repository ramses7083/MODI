//
//  DetailedTicketTableViewCell.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 26/11/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class DetailedTicketTableViewCell: UITableViewCell {
    @IBOutlet weak var precioRestaurantLabel: UILabel!
    @IBOutlet weak var nombreRestaurantLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
