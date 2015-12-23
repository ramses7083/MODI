//
//  SelectedRestaurantInterfaceController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 18/12/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import WatchKit
import Foundation


class SelectedRestaurantInterfaceController: WKInterfaceController {
    var idRestaurant : Int?
    var JSONrestaurant : JSON!
    var geopinArr : [String]?
    var telefono : String?
    var restaurants : JSON!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        JSONrestaurant = JSON(context!)
        print(JSONrestaurant)
        self.telefono = self.JSONrestaurant["telefono"].stringValue
        print("telefono:\(self.telefono)")
        let geopin = self.JSONrestaurant["geopin"].stringValue
        self.geopinArr = geopin.componentsSeparatedByString(",")
        dispatch_async(dispatch_get_main_queue()) {
            //     // update your UI and model objects here
            self.setTitle(self.JSONrestaurant["nombre"].stringValue)
        }
        // Configure interface objects here.
    }

    @IBAction func makeCall() {
        if let telURL=NSURL(string:"tel:\(self.telefono!)") {
            let wkExtension=WKExtension.sharedExtension()
            wkExtension.openSystemURL(telURL)
        }
    }
    @IBAction func viewMap() {
        print(geopinArr)
        pushControllerWithName("mapInterface", context: self.geopinArr)
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
