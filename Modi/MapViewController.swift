//
//  MapViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 10/06/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import Foundation
import Contacts

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var coordenadas: [Double]!
    var restaurantNombre: String!
    var restaurantCalle: String!
    var restaurantCategoria: String!
    @IBOutlet weak var RestaurantMapView: MKMapView!
    var locationManager: CLLocationManager!
    var latitude: Double!
    var longitude: Double!
    var annotationArray :[MKAnnotation]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerColor = UIColor(red: 223.0/255.0, green: 55.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = headerColor
        
        // Obtener localizacón del usuario
        RestaurantMapView.delegate = self
        locationManager =  CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if (self.locationManager.location != nil){
            let location = self.locationManager.location
            latitude = location!.coordinate.latitude
            longitude = location!.coordinate.longitude

            print("Latitud actual :: \(latitude)")
            print("Longitud actual :: \(longitude)")
            
            let latDelta:CLLocationDegrees = 0.24
            let longDelta:CLLocationDegrees = 0.24
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake((locationManager.location?.coordinate)!, theSpan)
            self.RestaurantMapView.setRegion(region, animated: true)
            
            var allLocations:[CLLocationCoordinate2D] = [
                CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!),
                CLLocationCoordinate2D(latitude: coordenadas[0], longitude: coordenadas[1] )
            ]
            
            let poly:MKPolygon = MKPolygon(coordinates: &allLocations, count: allLocations.count)
            
            self.RestaurantMapView.setVisibleMapRect(poly.boundingMapRect, edgePadding: UIEdgeInsetsMake(140.0, 140.0, 140.0, 140.0), animated: true)
        } else {
            RestaurantMapView.showAnnotations(RestaurantMapView.annotations, animated: true)
        }
        self.RestaurantMapView.showsUserLocation = true
        self.RestaurantMapView.mapType = MKMapType.Standard
        
        //Crear pin del Restaurante
        // show artwork on map
        let artwork = Artwork(title: "\(restaurantNombre)",
            locationName: "\(restaurantCalle)",
            discipline: "\(restaurantCategoria)",
            coordinate: CLLocationCoordinate2D(latitude: coordenadas[0], longitude: coordenadas[1]))
        
        RestaurantMapView.addAnnotation(artwork)

    }
 
    
    func locationManager(manager: CLLocationManager, requestLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.RestaurantMapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
    // pinColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    func pinColor() -> UIColor  {
        switch discipline {
        case "0", "4":
            return UIColor.redColor()
        case "1", "Monument":
            return UIColor.purpleColor()
        case "2", "Monument":
            return UIColor.greenColor()
        default:
            return UIColor.greenColor()
        }
    }
}
class AnnotationWithoutSimbol: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // pinColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    func pinColor() -> UIColor  {
        switch discipline {
        case "0", "4":
            return UIColor.redColor()
        case "1", "Monument":
            return UIColor.purpleColor()
        case "2", "Monument":
            return UIColor.greenColor()
        default:
            return UIColor.greenColor()
        }
    }
}

