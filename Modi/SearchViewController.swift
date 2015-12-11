//
//  SearchViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 05/05/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import Foundation
import Contacts

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //@IBOutlet weak var SearchTextField: UITextField!
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    @IBOutlet weak var SearchMapView: MKMapView!
    var locationManager: CLLocationManager!
    @IBOutlet var FoodTableView: UITableView!
    var RestaurantID: String!
    var RestaurantTag: Int!
    var contadorCategorias: Int = 0
    var contadorFilas: Int = 0
    var contadorFilasTable: Int = 0
    var categorias: JSON!
    var profile: JSON!
    var populares: JSON!
    var RestaurantesID: [[String]] = []
    var Restaurantes: [[String]] = []
    //var RestauranteLogos: [[Int]] = []
    var RestaurantesCalles: [[String]] = []
    var RestaurantesModiCliente: [[Bool]] = []
    var RestaurantesLogosURL: [[String]] = []
    var RestaurantesLogos: [[String]] = []
    var token = ""
    var databasePath = NSString()
    var categoriasTemp : JSON!
    var categoriasTodas : [String] = []
    var RestaurantesPineados : [String] = []
    var imageCache = [String:UIImage]()
    var pointLocation:CLLocationCoordinate2D!
    var RestaurantesLat: [[String]] = []
    var RestaurantesLong: [[String]] = []
    var favoritosStatus = false
    
    var contentsOffsetDictionary: NSMutableDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        print("tokenization:\(token)")

        //Personalizar el TabBarController
        
        // Editar SeaarchTextField
        /*SearchTextField.layer.borderWidth = 3.0
        SearchTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        */
        // Editar TableView
        FoodTableView.rowHeight = 114
        
        
        
        // Editar el header
        // Las siguientes lineas estan comentadas porque se configuro el navigationController en 
        /*let headerColor = UIColor(red: 55.0/255.0, green: 29.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = headerColor
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]*/
        //self.navigationItem.title = "Búsqueda"
        self.navigationItem.leftBarButtonItem?.title = "atras"
            
        downloadData()
        
        // Implementar Pull to Refresh a la tabla
        let refreshControl = UIRefreshControl()
        FoodTableView.addSubview(refreshControl)
        let RefreshControlColor = UIColor(red: 230.0/255.0, green: 74.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        refreshControl.tintColor = RefreshControlColor
        let RefreshTitleText = "Actualizando restaurantes" as NSString
        let attributedString = NSMutableAttributedString(string: RefreshTitleText as String)
        let firstAttributes = [NSForegroundColorAttributeName: RefreshControlColor, NSBackgroundColorAttributeName: UIColor.clearColor(), NSUnderlineStyleAttributeName: 0]
        attributedString.addAttributes(firstAttributes, range: RefreshTitleText.rangeOfString("Actualizando sensores"))
        refreshControl.attributedTitle = attributedString
        refreshControl.addTarget(self, action: "UpdateTable:", forControlEvents: .ValueChanged)
    }
    func downloadData() {
        //Limpiar variables
        RestaurantesID = []
        Restaurantes = []
        RestaurantesCalles = []
        RestaurantesModiCliente = []
        RestaurantesLogosURL = []
        RestaurantesLogos = []
        categoriasTodas = []
        imageCache = [String:UIImage]()
        
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        print("tokenization:\(token)")
        
        //Personalizar el TabBarController
        
        // Editar SeaarchTextField
        /*SearchTextField.layer.borderWidth = 3.0
        SearchTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        */
        // Editar TableView
        FoodTableView.rowHeight = 114
        
        //Obtener perfil
        profile = ConnectDB().getProfile(token)
        //print(profile[0]["favrestaurants"])
        //Obtener populares
        populares = ConnectDB().getPopular(token)
        //print(populares)
        //Obtener categorias
        categoriasTemp = ConnectDB().getCategories(token)
        print(categoriasTemp)
        categorias = categoriasTemp
    
        var cont = 0
        
        for var cc=0; cc<profile[0]["favrestaurants"].count ; cc++ {
            if cc == 0 {
                RestaurantesID.append([profile[0]["favrestaurants"][cc]["id"].stringValue])
                Restaurantes.append([profile[0]["favrestaurants"][cc]["nombre"].stringValue])
                RestaurantesCalles.append([profile[0]["favrestaurants"][cc]["calle"].stringValue])
                RestaurantesModiCliente.append([profile[0]["favrestaurants"][cc]["posClient"].boolValue])
                RestaurantesLogosURL.append([profile[0]["favrestaurants"][cc]["logo"].stringValue])
                RestaurantesLogos.append(["\(profile[0]["favrestaurants"][cc]["id"].stringValue).png"])
                let geopin = profile[0]["favrestaurants"][cc]["geopin"].stringValue
                let geopinArr = geopin.componentsSeparatedByString(",")
                RestaurantesLat.append([geopinArr[0]])
                RestaurantesLong.append([geopinArr[1]])
                cont += 1
                
                
                // Guardar imagen
                /*
                if restaurantesPorCatTem[cc]["logo"].stringValue == "" { url = NSURL(string: "http://modi.mx/media/images/orange_tapas_bar_LOGO.jpg")}
                else {url = NSURL(string: restaurantesPorCatTem[cc]["logo"].stringValue)}
                let data:NSData = NSData(contentsOfURL: url!)!
                let image = UIImage(data: data)
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                let imagePath = paths.stringByAppendingPathComponent("\(restaurantesPorCatTem[cc]["id"].stringValue).png" )
                UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                print("Guardo foto 0")
                */
            } else {
                RestaurantesID[0].append(profile[0]["favrestaurants"][cc]["id"].stringValue)
                Restaurantes[0].append(profile[0]["favrestaurants"][cc]["nombre"].stringValue)
                RestaurantesCalles[0].append(profile[0]["favrestaurants"][cc]["calle"].stringValue)
                RestaurantesModiCliente[0].append(profile[0]["favrestaurants"][cc]["posClient"].boolValue)
                RestaurantesLogosURL[0].append(profile[0]["favrestaurants"][cc]["logo"].stringValue)
                RestaurantesLogos[0].append("\(profile[0]["favrestaurants"][cc]["id"].stringValue).png")
                let geopin = profile[0]["favrestaurants"][cc]["geopin"].stringValue
                let geopinArr = geopin.componentsSeparatedByString(",")
                RestaurantesLat[0].append(geopinArr[0])
                RestaurantesLong[0].append(geopinArr[1])
                
                // Guardar imagen
                /*
                if restaurantesPorCatTem[cc]["logo"].stringValue == "" { url = NSURL(string: "http://modi.mx/media/images/orange_tapas_bar_LOGO.jpg")}
                else {url = NSURL(string: restaurantesPorCatTem[cc]["logo"].stringValue)}
                let data:NSData = NSData(contentsOfURL: url!)!
                let image = UIImage(data: data)
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                let imagePath = paths.stringByAppendingPathComponent("\(restaurantesPorCatTem[cc]["id"].stringValue).png")
                UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                print("Guardo foto 1")
                */
            }
        }
        
        //Guardar populares en el array
        for var cc=0; cc<populares.count ; cc++ {
            if cc == 0 {
                RestaurantesID.append([populares[cc]["id"].stringValue])
                Restaurantes.append([populares[cc]["nombre"].stringValue])
                RestaurantesCalles.append([populares[cc]["calle"].stringValue])
                RestaurantesModiCliente.append([populares[cc]["posClient"].boolValue])
                RestaurantesLogosURL.append([populares[cc]["logo"].stringValue])
                RestaurantesLogos.append(["\(populares[cc]["id"].stringValue).png"])
                let geopin = populares[cc]["geopin"].stringValue
                let geopinArr = geopin.componentsSeparatedByString(",")
                RestaurantesLat.append([geopinArr[0]])
                RestaurantesLong.append([geopinArr[1]])
                cont += 1
                
                // Guardar imagen
                /*
                if restaurantesPorCatTem[cc]["logo"].stringValue == "" { url = NSURL(string: "http://modi.mx/media/images/orange_tapas_bar_LOGO.jpg")}
                else {url = NSURL(string: restaurantesPorCatTem[cc]["logo"].stringValue)}
                let data:NSData = NSData(contentsOfURL: url!)!
                let image = UIImage(data: data)
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                let imagePath = paths.stringByAppendingPathComponent("\(restaurantesPorCatTem[cc]["id"].stringValue).png" )
                UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                print("Guardo foto 0")
                */
            } else {
                RestaurantesID[cont-1].append(populares[cc]["id"].stringValue)
                Restaurantes[cont-1].append(populares[cc]["nombre"].stringValue)
                RestaurantesCalles[cont-1].append(populares[cc]["calle"].stringValue)
                RestaurantesModiCliente[cont-1].append(populares[cc]["posClient"].boolValue)
                RestaurantesLogosURL[cont-1].append(populares[cc]["logo"].stringValue)
                RestaurantesLogos[cont-1].append("\(populares[cc]["id"].stringValue).png")
                let geopin = populares[cc]["geopin"].stringValue
                let geopinArr = geopin.componentsSeparatedByString(",")
                RestaurantesLat[cont-1].append(geopinArr[0])
                RestaurantesLong[cont-1].append(geopinArr[1])
                
                // Guardar imagen
                /*
                if restaurantesPorCatTem[cc]["logo"].stringValue == "" { url = NSURL(string: "http://modi.mx/media/images/orange_tapas_bar_LOGO.jpg")}
                else {url = NSURL(string: restaurantesPorCatTem[cc]["logo"].stringValue)}
                let data:NSData = NSData(contentsOfURL: url!)!
                let image = UIImage(data: data)
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                let imagePath = paths.stringByAppendingPathComponent("\(restaurantesPorCatTem[cc]["id"].stringValue).png")
                UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                print("Guardo foto 1")
                */
            }
        }
        
        // Obtener restaurantes por categoria
        for var c = 0; c<categorias.count; c++ {
            //let restaurantesPorCatTem = ConnectDB().getRestaurantsByCategory(token, id: categorias[c]["id"].stringValue)
            //print("Restaurantes de cat: \(categorias[c]["id"].stringValue) = \(restaurantesPorCatTem)")
            for var cc=0; cc<categorias[c]["restaurants"].count ; cc++ {
                if cc == 0 {
                    RestaurantesID.append([categorias[c]["restaurants"][cc]["id"].stringValue])
                    Restaurantes.append([categorias[c]["restaurants"][cc]["nombre"].stringValue])
                    RestaurantesCalles.append([categorias[c]["restaurants"][cc]["calle"].stringValue])
                    RestaurantesModiCliente.append([categorias[c]["restaurants"][cc]["posClient"].boolValue])
                    RestaurantesLogosURL.append([categorias[c]["restaurants"][cc]["logo"].stringValue])
                    RestaurantesLogos.append(["\(categorias[c]["restaurants"][cc]["id"].stringValue).png"])
                    let geopin = categorias[c]["restaurants"][cc]["geopin"].stringValue
                    let geopinArr = geopin.componentsSeparatedByString(",")
                    RestaurantesLat.append([geopinArr[0]])
                    RestaurantesLong.append([geopinArr[1]])
                    
                    // Guardar imagen
                    /*
                    if restaurantesPorCatTem[cc]["logo"].stringValue == "" { url = NSURL(string: "http://modi.mx/media/images/orange_tapas_bar_LOGO.jpg")}
                    else {url = NSURL(string: restaurantesPorCatTem[cc]["logo"].stringValue)}
                    let data:NSData = NSData(contentsOfURL: url!)!
                    let image = UIImage(data: data)
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                    let imagePath = paths.stringByAppendingPathComponent("\(restaurantesPorCatTem[cc]["id"].stringValue).png" )
                    UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                    print("Guardo foto 0")
                    */
                } else {
                    RestaurantesID[c+cont].append(categorias[c]["restaurants"][cc]["id"].stringValue)
                    Restaurantes[c+cont].append(categorias[c]["restaurants"][cc]["nombre"].stringValue)
                    RestaurantesCalles[c+cont].append(categorias[c]["restaurants"][cc]["calle"].stringValue)
                    RestaurantesModiCliente[c+cont].append(categorias[c]["restaurants"][cc]["posClient"].boolValue)
                    RestaurantesLogosURL[c+cont].append(categorias[c]["restaurants"][cc]["logo"].stringValue)
                    RestaurantesLogos[c+cont].append("\(categorias[c]["restaurants"][cc]["id"].stringValue).png")
                    let geopin = categorias[c]["restaurants"][cc]["geopin"].stringValue
                    let geopinArr = geopin.componentsSeparatedByString(",")
                    RestaurantesLat[c+cont].append(geopinArr[0])
                    RestaurantesLong[c+cont].append(geopinArr[1])
                    
                    // Guardar imagen
                    /*
                    if restaurantesPorCatTem[cc]["logo"].stringValue == "" { url = NSURL(string: "http://modi.mx/media/images/orange_tapas_bar_LOGO.jpg")}
                    else {url = NSURL(string: restaurantesPorCatTem[cc]["logo"].stringValue)}
                    let data:NSData = NSData(contentsOfURL: url!)!
                    let image = UIImage(data: data)
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                    let imagePath = paths.stringByAppendingPathComponent("\(restaurantesPorCatTem[cc]["id"].stringValue).png")
                    UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                    print("Guardo foto 1")
                    */
                }
            }
        }
        
        for var c = 0; c < categorias.count; c++ {
            if c == 0 {
                if cont == 2 { categoriasTodas.append("Favoritos") }
                categoriasTodas.append("Populares")
                categoriasTodas.append(categorias[c]["name"].stringValue)
            } else {
                categoriasTodas.append(categorias[c]["name"].stringValue)
            }
        }
        
        
        //print("Datos de API restaurantes: \(Restaurants)")
        //let temp = Restaurants.count
        //print("Restauran: \(temp)")
        //println("Restauran: \(Restaurants)")
        
        //Obtener datos del menu
        /*
        var menu = ConnectDB().getMenu(1)
        var temp2 = menu[0]["menu"].string
        var temp3 = JSON(temp2!)
        var temp4 = temp3["idCategoria"]
        temp = temp3.count
        println("Menu: \(temp4)")
        //println("Menu: \(menu)")
        */
        // Obtener localizacón del usu ario
        locationManager =  CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if (self.locationManager.location != nil){
            let location = self.locationManager.location
            let latitude: Double = location!.coordinate.latitude
            let longitude: Double = location!.coordinate.longitude
            
            print("Latitud actual :: \(latitude)")
            print("Longitud actual :: \(longitude)")
            
            let latDelta:CLLocationDegrees = 0.04
            let longDelta:CLLocationDegrees = 0.04
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake((locationManager.location?.coordinate)!, theSpan)
            self.SearchMapView.setRegion(region, animated: true)
        }
        self.SearchMapView.showsUserLocation = true
        self.SearchMapView.mapType = MKMapType.Standard
        
        // Generar los Pines de los restaurantes
        SearchMapView.delegate = self
        for var x = 0; x < Restaurantes.count; x++
        {//print("Entro a X")
            for var y = 0; y < Restaurantes[x].count; y++
            {//print("Entro a y")
                var ban = false
                for var z = 0; z < RestaurantesPineados.count; z++
                {
                    if RestaurantesID[x][y] == RestaurantesPineados[z] {
                        ban = true
                    }
                }
                if !ban {
                    //Crear pin del Restaurante
                    // show artwork on map
                    let latitud =  (RestaurantesLat[x][y] as NSString).doubleValue
                    let longitud = (RestaurantesLong[x][y] as NSString).doubleValue
                    let nartwork = NArtwork(title: "\(Restaurantes[x][y])",
                        locationName: "\(RestaurantesCalles[x][y])",
                        discipline: "\(x)",
                        coordinate: CLLocationCoordinate2D(latitude:  latitud, longitude:  longitud))
                    SearchMapView.addAnnotation(nartwork)
                    RestaurantesPineados.append(RestaurantesID[x][y])
                }
            }
        }
        
    }
    func UpdateTable(refreshControl: UIRefreshControl) {
        downloadData()
        FoodTableView.reloadData()
        print("tabla actualizada")
        refreshControl.endRefreshing()
    }
    func documentsDirectory() -> NSString {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        return documentsFolderPath
    }
    // Get path for a file in the directory
    
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.SearchMapView.setRegion(region, animated: true)
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoriasTodas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath) as! RestaurantCell
        cell.CategoryRestaurant?.text = categoriasTodas[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.tag = indexPath.row
        let CV: RestaurantCell = cell as! RestaurantCell
        CV.SearchCV.tag = indexPath.row
        //collectionView.cellForItemAtIndexPath(indexPath)
        CV.SearchCV.cellForItemAtIndexPath(indexPath)
        CV.SearchCV.reloadData()
        //print("Index del SearchTag \(CV.SearchCV.tag)")
        print("Index del WillDisplay \(CV.tag)")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         print("Seleccionaste la fila #\(indexPath.row)!")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var contadorItems: Int = 0
        contadorItems = Restaurantes[collectionView.tag].count
        print("contadorItems: \(contadorItems)")
        //print("ContadorFilas = \(Restaurantes[contadorFilas].count)")
        //contadorFilas += 1
        return contadorItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let Cell: RestaurantCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! RestaurantCollectionViewCell
        Cell.RestaurantLabel?.text = Restaurantes[collectionView.tag][indexPath.item]
        print("Imagen: \( RestaurantesLogos[collectionView.tag][indexPath.item])")
        
        //Cell.RestaurantImageView?.image = UIImage(contentsOfFile: imagePath)
        Cell.RestaurantImageView?.image = UIImage(named: "ModiIcon@2x.png")
        
        // If this image is already cached, don't re-download
        let urlString = RestaurantesLogosURL[collectionView.tag][indexPath.item]
        let imgURL = NSURL(string: urlString)
        if let img = imageCache[urlString] {
            Cell.RestaurantImageView?.image = img
        }
        else {
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data!)
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        Cell.RestaurantImageView?.image = image
                        /*if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) {
                            Cell.RestaurantImageView?.image = image
                        }*/
                    })
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
        }
        
        
        if RestaurantesModiCliente[collectionView.tag][indexPath.item] == true { Cell.ModiPosImageView.hidden = false }
            else { Cell.ModiPosImageView.hidden = true }
        return Cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /*dispatch_async(dispatch_get_main_queue(), {
            self.progressBarDisplayer("Descargando", true)
        })*/
        RestaurantID = RestaurantesID[collectionView.tag][indexPath.item]
        print("Seleccionaste el collection \(Restaurantes[collectionView.tag][indexPath.item]) y el tag: \(collectionView.tag)! con ID: \(RestaurantID)")
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("RestaurantSelectedSegue", sender: self)
        })
        
    }
    
    // Ajustar tamaño del Collection View Item
    /*
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 90, height: 82);
    }
    */
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicatorM = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicatorM.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicatorM.startAnimating()
            messageFrame.addSubview(activityIndicatorM)
            messageFrame.addSubview(strLabel)
            messageFrame.tag = 100
            view.addSubview(messageFrame)
        } else {
            for subview in view.subviews {
                if (subview.tag == 100) {
                    subview.removeFromSuperview()
                }
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "RestaurantSelectedSegue") {
            let vc : RestaurantDetailViewController = segue.destinationViewController as! RestaurantDetailViewController
            vc.RestaurantID = RestaurantID
            let backItem = UIBarButtonItem()
            backItem.title = "Principal"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Editar el header
        /*let headerColor = UIColor(red: 55.0/255.0, green: 29.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = headerColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.title = "Búsquedasss"*/
        //downloadData()
        //FoodTableView.reloadData()
        print("statusFavoritos\(favoritosStatus)")
        print("SearchViewController reload")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    class NArtwork: NSObject, MKAnnotation {
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
