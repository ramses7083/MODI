//
//  RestaurantDetailViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 10/06/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var LocationButton: UIButton!
    @IBOutlet weak var FavouriteCheckBox: FavCheckBox!
    @IBOutlet weak var AgregarFavoritoLabel: UILabel!
    @IBOutlet weak var RestaurantNameLabel: UILabel!
    @IBOutlet weak var RestaurantDescriptionLabel: UILabel!
    @IBOutlet weak var StateLabel: UILabel!
    @IBOutlet weak var Street2Label: UILabel!
    @IBOutlet weak var StreetLabel: UILabel!
    @IBOutlet weak var RestaurantImageView: UIImageView!
    @IBOutlet weak var TelefonoButton: UIButton!
    @IBOutlet weak var rate1ImageView: UIImageView!
    @IBOutlet weak var rate2ImageView: UIImageView!
    @IBOutlet weak var rate3ImageView: UIImageView!
    @IBOutlet weak var rate4ImageView: UIImageView!
    @IBOutlet weak var rate5ImageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    var telefono : String!
    var imageCache = [String:UIImage]()
    var databasePath = NSString()
    var RestaurantID: String!
    var token = ""
    var lat : Double!
    var long : Double!
    var schedule = ""
    var RestaurantHeader : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        progressBarDisplayer("Descargando", true)
        FavouriteCheckBox.isChecked = false
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        FavouriteCheckBox.restaurantID = RestaurantID
        FavouriteCheckBox.token = token
        let result = ConnectDB().getRestaurantDetails(token, id: RestaurantID)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(result) { data, response, error in
            if error != nil {
                // handle error here
                print("Error al principio")
                print(error)
                return
            }
            
            // if response was JSON, then parse it
            
            do {
                if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("success == \(responseDictionary)")
                    
                    // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                    //
                    dispatch_async(dispatch_get_main_queue()) {
                        //     // update your UI and model objects here
                        
                        self.RestaurantNameLabel.text? = responseDictionary["nombre"]! as! String
                        self.StreetLabel.text? = "\(responseDictionary["calle"]!) \(responseDictionary["numeroExt"]!) \(responseDictionary["numeroInt"]!)"
                        self.Street2Label.text? = responseDictionary["colonia"]! as! String
                        self.StateLabel.text? = responseDictionary["municipio"]! as! String
                        self.RestaurantDescriptionLabel.text? = responseDictionary["descripcion"]! as! String
                        self.telefono = responseDictionary["telefono"]! as! String
                        self.TelefonoButton.setTitle(self.telefono, forState: .Normal)
                        let posCliente = responseDictionary["posClient"]! as! Bool
                        if posCliente {
                            self.MenuButton.hidden = false
                        } else {
                            self.MenuButton.hidden = true
                        }
                        let geopin = responseDictionary["geopin"]! as! String
                        let geopinArr = geopin.componentsSeparatedByString(",")
                        self.lat = (geopinArr[0] as NSString).doubleValue
                        self.long = (geopinArr[1] as NSString).doubleValue
                        print("lat\(self.lat) long\(self.long)")
                        let favorite  = responseDictionary["favorite"]! as! Bool
                        if  favorite {
                            self.FavouriteCheckBox.isChecked = true
                        } else {
                            self.FavouriteCheckBox.isChecked = false
                        }
                        let rating = responseDictionary["rating"]! as! Int
                        if rating == 1 {
                            self.rate1ImageView.image = UIImage(named: "rate+.png")
                        }
                        if rating == 2 {
                            self.rate1ImageView.image = UIImage(named: "rate+.png")
                            self.rate2ImageView.image = UIImage(named: "rate+.png")
                        }
                        if rating == 3 {
                            self.rate1ImageView.image = UIImage(named: "rate+.png")
                            self.rate2ImageView.image = UIImage(named: "rate+.png")
                            self.rate3ImageView.image = UIImage(named: "rate+.png")
                        }
                        if rating == 4 {
                            self.rate1ImageView.image = UIImage(named: "rate+.png")
                            self.rate2ImageView.image = UIImage(named: "rate+.png")
                            self.rate3ImageView.image = UIImage(named: "rate+.png")
                            self.rate4ImageView.image = UIImage(named: "rate+.png")
                        }
                        if rating == 5 {
                            self.rate1ImageView.image = UIImage(named: "rate+.png")
                            self.rate2ImageView.image = UIImage(named: "rate+.png")
                            self.rate3ImageView.image = UIImage(named: "rate+.png")
                            self.rate4ImageView.image = UIImage(named: "rate+.png")
                            self.rate5ImageView.image = UIImage(named: "rate+.png")
                        }
                        print("termino de cargar los datos")
                        //Descargar imagen
                        
                        let urlString = "\(responseDictionary["cabecera"]!)"
                        let imgURL = NSURL(string: urlString)
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
                                    self.RestaurantHeader = image
                                    self.RestaurantImageView.image = image
                                    self.progressBarDisplayer("Descargando", false)
                                })
                            }
                            else {
                                print("Error: \(error!.localizedDescription)")
                            }
                        })
                        
                    }
                    
                    
                }
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
        }
        task.resume()
        
        let result2 = ConnectDB().getRestaurantSchedules(token, id: RestaurantID)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(result2) { data, response, error in
            if error != nil {
                // handle error here
                print("Error al principio")
                print(error)
                return
            }
            
            // if response was JSON, then parse it
            let respuestaServidor = JSON(data: data!, options: [], error: nil)
            //print("resp:\(respuestaServidor)")
            dispatch_async(dispatch_get_main_queue()) {
                //     // update your UI and model objects here
                for var c = 0; c < respuestaServidor.count; c++ {
                    self.schedule = "\(self.schedule)\(respuestaServidor[c]["dias"]) \(respuestaServidor[c]["horaIni"]) - \(respuestaServidor[c]["horaFin"]); "
                }
                
                print("\(self.schedule)")
            }

            do {
                if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("success == \(responseDictionary)")
                    
                    // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                    //
                    dispatch_async(dispatch_get_main_queue()) {
                        //     // update your UI and model objects here
                
                        self.schedule = "\(respuestaServidor[0]["dias"]) \(respuestaServidor[0]["horaIni"]) - \(respuestaServidor[0]["horaFin"])"
                        print("s:\(self.schedule)")
                    }
                    
                    
                }
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
        }
        task2.resume()
        
        if datosSesion[1] as! String == "guest" {
            FavouriteCheckBox.hidden = true
            AgregarFavoritoLabel.hidden = true
            rateButton.hidden = true
        }
        
        // Diseñar los botones
        /*let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let spacing : CGFloat = screenWidth*0.38; // the amount of spacing to appear between image and title
        LocationButton.imageEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        LocationButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing+10, 0, 0);
        //var size = CGSize(width: 100, height: 30)
        
        
        MenuButton.imageEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        MenuButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing+10, 0, 0);
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MenuButton(sender: AnyObject) {
        self.performSegueWithIdentifier("RestaurantSelectedSegue", sender: self)
    }

    @IBAction func LocalizationButton(sender: AnyObject) {
        self.performSegueWithIdentifier("MapSegue", sender: self)
    }
    
    @IBAction func scheduleButton(sender: AnyObject) {
        let optionAlert = UIAlertController(title: "Horarios", message: schedule, preferredStyle: UIAlertControllerStyle.Alert)
        optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
        }))
        self.presentViewController(optionAlert, animated: true, completion: nil)
    }
    
    @IBAction func CallTelephone(sender: AnyObject) {
        let urlTelefono:NSURL = NSURL(string: "tel://\(telefono)")!
        UIApplication.sharedApplication().openURL(urlTelefono)
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
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
            let vc : SelectedRestaurantViewController = segue.destinationViewController as! SelectedRestaurantViewController
            vc.RestautanteID = RestaurantID
            vc.imagen = RestaurantHeader
            let backItem = UIBarButtonItem()
            backItem.title = "Restaurante"
            navigationItem.backBarButtonItem = backItem
        }
        if(segue.identifier == "MapSegue") {
            let vc : MapViewController = segue.destinationViewController as! MapViewController
            vc.coordenadas = [lat, long]
            vc.restaurantNombre = RestaurantNameLabel.text!
            vc.restaurantCalle = StreetLabel.text!
            vc.restaurantCategoria = "0"
            let backItem = UIBarButtonItem()
            backItem.title = "Regresar"
            backItem.tintColor = UIColor.redColor()
            navigationItem.backBarButtonItem = backItem
        }
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destinationViewController as! PopupViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.RestauranteId = RestaurantID
        }
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
