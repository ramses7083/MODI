//
//  MyOrderViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 04/06/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class MyOrderViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var MyOrderTableView: UITableView!
    var databasePath = NSString()
    @IBOutlet weak var sendOrderButton: UIButton!
    let cellColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    var myorder: [[String]] = []
    var token : String!
    var RestaurantID : String!
    var Mesa : String!
    var total: Double = 0
    @IBOutlet weak var totalLabel: UILabel!
    var alert = UIAlertController(title: "Listo", message: "Pedido enviado!", preferredStyle: UIAlertControllerStyle.Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        myorder = connectDB.checkOrder(databasePath as String)
        print("myorder:\(myorder)")
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        RestaurantID = datosSesion[7] as! String
        Mesa = datosSesion[8] as! String
        
        // Do any additional setup after loading the view.
        
        //Editar TableView
        MyOrderTableView.allowsSelection = false
        // Ocultar filas sin informacion
        let tblView =  UIView(frame: CGRectZero)
        MyOrderTableView.tableFooterView = tblView
        MyOrderTableView.tableFooterView?.hidden = true
        MyOrderTableView.backgroundColor = UIColor.clearColor()
        print("RID:\(RestaurantID)")
        if (myorder.count == 0 || RestaurantID == "0") {
            sendOrderButton.enabled = false
            sendOrderButton.alpha = 0.5
        } else {
            sendOrderButton.enabled = true
            sendOrderButton.alpha = 1.0
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myorder.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = self.FoodTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        //cell.textLabel?.text = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! MyOrderTableViewCell
        if (indexPath.row%2 != 0 ){
            cell.FoodNameLabel.text = myorder[indexPath.row][2]
            cell.PriceLabel.text = "$\(myorder[indexPath.row][3])"
            cell.backgroundColor = cellColor
        } else {
            cell.FoodNameLabel.text = myorder[indexPath.row][2]
            cell.PriceLabel.text = "$\(myorder[indexPath.row][3])"
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
     
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Seleccionaste la fila #\(indexPath.row)!")
        
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Eliminar"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            print("articulo borrado con id: \(myorder[indexPath.row][0])")
            ConnectDB().deleteProduct(databasePath as String, Id: Int(myorder[indexPath.row][0])!)
            UpdateTable()
            
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    @IBAction func sendOrder(sender: AnyObject) {
        
        let optionAlert = UIAlertController(title: "Enviar pedido", message: "Este pedido será enviado, revise bien cada platillo", preferredStyle: UIAlertControllerStyle.Alert)
        
        optionAlert.addAction(UIAlertAction(title: "Esperar", style: .Default, handler: { (action: UIAlertAction) in
            ConnectDB().updateRestaurant(self.databasePath, idRestaurant: 0, idMesa: 0)
            print("Handle Cancel Logic here")
        }))
        
        optionAlert.addAction(UIAlertAction(title: "ENVIAR", style: .Default, handler: { (action: UIAlertAction) in
            print("User accepted")
            let connectDB = ConnectDB()
            
            self.orderFinished()
            var comanda = "["
            for var c = 0; c < self.myorder.count ; c++ {
                if c != 0 {comanda = "\(comanda),"}
                comanda = "\(comanda){\"id_producto\":\(self.myorder[c][1]),\"personalizacion\":\"\(self.myorder[c][4])\"}"
            }
            comanda = "\(comanda)]"
            let result = ConnectDB().sendTicket(self.token, idRestaurant: self.RestaurantID, Mesa: self.Mesa, comanda: comanda)
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
                            connectDB.cleanOrder(self.databasePath as String)
                            ConnectDB().updateRestaurant(self.databasePath, idRestaurant: 0, idMesa: 0)
                            self.UpdateTable()
                            
                        }
                        
                        
                    }
                } catch {
                    print(error)
                    
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("responseString = \(responseString)")
                }
            }
            task.resume()
            // Convertir el string escapada a JSON (no funciona)
            /*
            print("comanda: \(comanda)")
            comanda = comanda.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            var comandaJSON : JSON!
            if let dataFromString = comanda.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                comandaJSON = JSON(data: dataFromString)
            }
            print("comandaJson: \(comandaJSON)")
            */
        }))
        
        presentViewController(optionAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func finishSesion(sender: AnyObject) {
        let optionAlert = UIAlertController(title: "Finalizar mesa", message: "Al finalizar la mesa se solicitará la cuenta", preferredStyle: UIAlertControllerStyle.Alert)
        
        optionAlert.addAction(UIAlertAction(title: "Esperar", style: .Default, handler: { (action: UIAlertAction) in
            ConnectDB().updateRestaurant(self.databasePath, idRestaurant: 0, idMesa: 0)
            print("Handle Cancel Logic here")
        }))
        
        optionAlert.addAction(UIAlertAction(title: "Finalizar", style: .Default, handler: { (action: UIAlertAction) in
            print("Se pregunto sobre el relleno de la encuesta")
            let optionAlert2 = UIAlertController(title: "Cuenta finalizada", message: "¿Deseas completar una encuesta de mejora del servicio?", preferredStyle: UIAlertControllerStyle.Alert)
            
            optionAlert2.addAction(UIAlertAction(title: "NO", style: .Default, handler: { (action: UIAlertAction) in
                ConnectDB().updateRestaurant(self.databasePath, idRestaurant: 0, idMesa: 0)
                print("No quiso llenar la encuesta")
            }))
            
            optionAlert2.addAction(UIAlertAction(title: "SI", style: .Default, handler: { (action: UIAlertAction) in
                print("SI quiso llenar la encuesta")
                self.performSegueWithIdentifier("pollSegue", sender: self)
            }))
            self.presentViewController(optionAlert2, animated: true, completion: nil)
        }))
        
        presentViewController(optionAlert, animated: true, completion: nil)

    }
    func UpdateTable() {
        // Pedir nuevamente los datos
        //Revisar la sesión previa
        //total = 0
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        myorder = connectDB.checkOrder(databasePath as String)
        print("Tamaño de la orden \(myorder.count) con detalles \(myorder)")
        total = 0.00
        for var c = 0; c < myorder.count; c++ {
            total += Double(myorder[c][3])!
        }
        totalLabel.text = "$\(total)"
        if (myorder.count == 0 || RestaurantID == "0") {
            sendOrderButton.enabled = false
            sendOrderButton.alpha = 0.5
        } else {
            sendOrderButton.enabled = true
            sendOrderButton.alpha = 1.0
        }
        self.MyOrderTableView.reloadData()
        print("Tabla de ordenes actualizada")
        
    }
    
    func orderFinished() {
        self.UpdateTable()
        self.presentViewController(alert, animated: true, completion: nil)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("dismissAlert"), userInfo: nil, repeats: false)
    }
    func dismissAlert()
    {
        // Dismiss the alert from here
        alert.dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
        
    }
    func sendRequest(result: NSURLRequest) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(result) { data, response, error in
            if error != nil {
                // handle error here
                print("Error al principio")
                print(error)
                return
            }
            
            // if response was JSON, then parse it
            //let respuestaServidor = JSON(data: data!, options: [], error: nil)
            //print(respuestaServidor)
            
            do {
                if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("success == \(responseDictionary)")
                }
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
            
        }
        task.resume()
    }
    /*
    func getLastTicket() {
        let result = ConnectDB().getTickets(token)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(result) { data, response, error in
            if error != nil {
                // handle error here
                print("Error al principio")
                print(error)
                return
            }
            
            // if response was JSON, then parse it
            let respuestaServidor = JSON(data: data!, options: [], error: nil)
            print(respuestaServidor)
            
            if respuestaServidor[0] != nil {
                let poll : Bool = respuestaServidor[0]["poll"].boolValue
                if poll {
                    
                }
            }
            
        }
        task.resume()
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        myorder = connectDB.checkOrder(databasePath as String)
        let datosSesion = connectDB.checkSession(databasePath as String)
        print(datosSesion)
        token = datosSesion[6] as! String
        RestaurantID = datosSesion[7] as! String
        Mesa = datosSesion[8] as! String
        UpdateTable()
        //getLastTicket()
        //self.tableView.reloadData()
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
