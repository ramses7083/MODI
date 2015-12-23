//
//  RestaurantesInterfaceController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 18/12/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import WatchKit
import Foundation


class RestaurantesInterfaceController: WKInterfaceController {
    @IBOutlet var RestaurantsTable: WKInterfaceTable!
    var restaurants : JSON!
    var JSONrestaurantes : JSON!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        JSONrestaurantes = JSON(context!)
        //print(JSONrestaurantes)
        dispatch_async(dispatch_get_main_queue()) {
            //     // update your UI and model objects here
            self.RestaurantsTable.setNumberOfRows(self.JSONrestaurantes["restaurants"].count, withRowType: "restaurantRow")
            self.setTitle(self.JSONrestaurantes["name"].stringValue)
            for index in 0..<self.RestaurantsTable.numberOfRows {
                if let controller = self.RestaurantsTable.rowControllerAtIndex(index) as? RestaurantesTable {
                    controller.restaurant = self.JSONrestaurantes["restaurants"][index]["nombre"].stringValue
                    //controller.restaurant = self.restaurants[index]["name"].stringValue
                }
            }
            
        }
    }
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let JSONrestaurante : JSON = JSONrestaurantes["restaurants"][rowIndex]
        let JSONrestauranteObject = JSONrestaurante.object
        pushControllerWithName("selectedRestaurant", context: JSONrestauranteObject)
        //print("selecciono: \(JSONrestaurante)")
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
