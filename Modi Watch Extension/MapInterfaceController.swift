//
//  MapInterfaceController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 18/12/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation


class MapInterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    @IBOutlet var mapView: WKInterfaceMap!
    var geopinArr : [String]?
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        geopinArr = context as! [String]?
        print("geolocalizacion: \(geopinArr)")
        let latitud =  (geopinArr![0] as NSString).doubleValue
        let longitud = (geopinArr![1] as NSString).doubleValue
        // Configure interface objects here.
        // Determine a location to display - Apple headquarters
        let mapLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitud, longitud)
        //
        let coordinateSpan : MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1);
        
        // Other colors include red and green pins
        self.mapView.addAnnotation(mapLocation, withPinColor: WKInterfaceMapPinColor.Red)
        self.mapView.setRegion(MKCoordinateRegion(center: mapLocation, span: coordinateSpan))
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        */
        print("Did get a location.")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Did fail to retrieve a location.")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status)
    }
    
    @IBAction func btnRequestLocation() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

}
