//
//  SelectedRestaurantViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 09/06/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class SelectedRestaurantViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    @IBOutlet weak var RestaurantImageView: UIImageView!
    @IBOutlet weak var SelectedRestaurantTableView: UITableView!
    var categoriaID: Int!
    var FoodSelected: String!
    var categoria: String!
    var selected: Int = 0
    let cellColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    var RestautanteID = "1"
    var categoriasNombres : [String] = [""]
    var categoriasID : [String] = [""]
    var databasePath = NSString()
    var token = ""
    var imagen : UIImage!
    var menuJson : JSON!
    var qrViewController = false
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarDisplayer("Descargando", true)
       
        if qrViewController {
            self.navigationItem.setHidesBackButton(true, animated: true)
            let rightItem = UIBarButtonItem(title: "Cerrar mesa", style: .Plain, target: self, action: "ejectTable:")
            navigationItem.rightBarButtonItem = rightItem
            navigationItem.setHidesBackButton(true, animated: true)
        }
        
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        self.RestaurantImageView.image = self.imagen
        let result = ConnectDB().getMenu(token, id: RestautanteID)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(result) { data, response, error in
            if error != nil {
                // handle error here
                print("Error al principio")
                print(error)
                return
            }
            
            // if response was JSON, then parse it
            let respuestaServidor = JSON(data: data!, options: [], error: nil)
            var menu = respuestaServidor[0]["menu"].stringValue
            menu = String(menu)
            //menu = menu.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            if let dataFromString = menu.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                self.menuJson = JSON(data: dataFromString)
            }
            print("menu: \(self.menuJson)")
            self.categoriasNombres = []
            self.categoriasID = []
            for var c = 0; c < self.menuJson.count; c++ {
                self.categoriasNombres.append(self.menuJson[c]["descripcion"].stringValue)
                self.categoriasID.append(self.menuJson[c]["idCategoria"].stringValue)
            }
            dispatch_async(dispatch_get_main_queue()) {
                //     // update your UI and model objects here
                //let imagen = UIImage(data: self.dataImage!)
                self.SelectedRestaurantTableView.reloadData()
                self.progressBarDisplayer("Descargando", false)
                
            }
            
            
            do {
                if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("success == \(responseDictionary)")
                    
                    // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                    //
                    dispatch_async(dispatch_get_main_queue()) {
                        //     // update your UI and model objects here
                        //let imagen = UIImage(data: self.dataImage!)
                        
                    }
                    
                    
                }
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
        }
        task.resume()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categoriasNombres.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectedRestaurantTableViewCell", forIndexPath: indexPath) as! SelectedRestaurantTableViewCell
        cell.CategoryFood?.text = self.categoriasNombres[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if (indexPath.row%2 == 0 ){
            cell.backgroundColor = cellColor
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.tag = indexPath.row
      
        //let CV: SelectedRestaurantTableViewCell = cell as! SelectedRestaurantTableViewCell
        //CV.MenuCV.tag = indexPath.row
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Seleccionaste la categoria #\(categoriasNombres[indexPath.row]) con ID \(categoriasID[indexPath.row])!")
        categoria = categoriasNombres[indexPath.row]
        categoriaID = Int(categoriasID[indexPath.row])
        selected = indexPath.row
        self.performSegueWithIdentifier("CategoryDetailsSegue", sender: self)
        
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
    /*
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularesCollection.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let Cell: SelectedRestaurantCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("SelectedRestaurantCollectionViewCell", forIndexPath: indexPath) as! SelectedRestaurantCollectionViewCell

            Cell.FoodLabel?.text = popularesCollection[indexPath.item]
            Cell.FoodImageView?.image = UIImage(named: popularesCollection[indexPath.item])
        return Cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        ProductID = indexPath.item
        self.performSegueWithIdentifier("FoodDetailSegue", sender: self)
    }*/
    
    func ejectTable(sender: UIBarButtonItem) {
        print("cerro mesa el usuario")
        ConnectDB().updateRestaurant(self.databasePath, idRestaurant: 0, idMesa: 0)
        navigationController?.popViewControllerAnimated(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CategoryDetailsSegue") {
            let vc : SelectedCategoryViewController = segue.destinationViewController as! SelectedCategoryViewController
            vc.categoria = categoria
            vc.RestauranteID = RestautanteID
            vc.selected = selected
            vc.menu = menuJson
            vc.imagen = imagen
            let backItem = UIBarButtonItem()
            backItem.title = "Menú"
            navigationItem.backBarButtonItem = backItem
        }
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
