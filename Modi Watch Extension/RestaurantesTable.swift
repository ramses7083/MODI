//
//  RestaurantesTable.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 18/12/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import WatchKit

class RestaurantesTable: NSObject {
    @IBOutlet var restaurantLabel: WKInterfaceLabel!
    var restaurant: String? {
        didSet {
            if let restaurant = restaurant {
                restaurantLabel.setText(restaurant)
            }
        }
    }

}
