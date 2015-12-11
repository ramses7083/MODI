//
//  DetailedTicketTableViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 26/11/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class DetailedTicketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var historialDetalleTableView: UITableView!
    var databasePath = NSString()
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    var token = ""
    var RestauranteID = ""
    var comandaAnterior = ""
    let cellColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    var idSelected = 0
    var menuJson : JSON!
    var comandaJson : JSON!
    var articulosNombres : [String] = []
    var articulosPrecios : [String] = []
    @IBOutlet weak var detallesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarDisplayer("Descargando", true)
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        updateTable()
        
        //Desescapar menu
        //print("comandaSinEscape:\(menuAnterior)")
        //El siguiente método está comentado porque no se requiere escapar al usar Swiftyjson
        /*
        menuAnterior = menuAnterior.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print("comandaConEscape:\([menuAnterior])")
        */
        if let dataFromString = comandaAnterior.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            self.comandaJson = JSON(data: dataFromString)
        }
        print("comandaJSON: \(self.comandaJson)")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articulosNombres.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detalleTicketCell", forIndexPath: indexPath) as! DetailedTicketTableViewCell
        cell.nombreRestaurantLabel.text = articulosNombres[indexPath.row]
        cell.precioRestaurantLabel.text = "$\(articulosPrecios[indexPath.row])"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if (indexPath.row%2 != 0 ){
            cell.backgroundColor = cellColor
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        cell.tag = indexPath.row
        print(cell.tag)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Seleccionaste el ticket de la fila #\(indexPath.row)!")
    }
    func updateTable() {
        let result = ConnectDB().getMenu(token, id: RestauranteID)
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
            print("menu restaurant: \(self.menuJson)")
            for var alim = 0; alim < self.comandaJson.count; alim++ {
                for var cat = 0; cat < self.menuJson.count; cat++ {
                    for var art = 0; art < self.menuJson[cat]["articulos"].count; art++ {
                        if self.comandaJson[alim]["id_producto"].stringValue == self.menuJson[cat]["articulos"][art]["idplatillo"].stringValue {
                            self.articulosNombres.append(self.menuJson[cat]["articulos"][art]["descripcion"].stringValue)
                            self.articulosPrecios.append(self.menuJson[cat]["articulos"][art]["precio"].stringValue)
                            break
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                //     // update your UI and model objects here
                //let imagen = UIImage(data: self.dataImage!)
                self.historialDetalleTableView.reloadData()
                self.progressBarDisplayer("Descargando", false)
                
            }
            
        }
        task.resume()
    }
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 95 , width: 180, height: 50))
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

}
