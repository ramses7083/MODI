//
//  RestaurantCell.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 06/05/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    var collectionViewCellIdentifier: NSString = "Cell"
    @IBOutlet weak var SearchCV: UICollectionView!
    @IBOutlet var CategoryRestaurant:UILabel!
    //var CV: RestaurantCollectionViewCell!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
