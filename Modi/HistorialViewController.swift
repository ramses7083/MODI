//
//  HistorialTableViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 25/11/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class HistorialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var historialTableView: UITableView!
    var databasePath = NSString()
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    var token = ""
    var tickets: [String] = []
    var comandas: [String] = []
    var restauranteID: [String] = []
    let cellColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    var idSelected = 0
    var pollStatus = true
    var ticketStatus = 0
    var restaurantNombreTicket = ""
    var restaurantIdTicket = 0
    var ticket = 0
    var dateTicket = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarDisplayer("Descargando", true)
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        
        // Editar Navigation Bar
        /*self.navigationController?.navigationBar.tintColor = UIColor.blueColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let headerColor = UIColor(red: 55.0/255.0, green: 29.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = headerColor*/

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
        return tickets.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historialCell", forIndexPath: indexPath) as! HistorialTableViewCell
        cell.historialCellLabel.text = tickets[indexPath.row]
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
        idSelected = indexPath.row
        self.performSegueWithIdentifier("historialDetalleSegue", sender: self)
    }
    func updateTable() {
        tickets = []
        comandas = []
        restauranteID = []
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
            //print(respuestaServidor)
            
            for var c = 0; c < respuestaServidor.count; c++ {
                if c == 0 {
                    self.pollStatus = respuestaServidor[0]["poll"].boolValue
                    self.ticketStatus = respuestaServidor[0]["status"].intValue
                    self.restaurantNombreTicket = respuestaServidor[0]["restaurant"]["nombre"].stringValue
                    self.restaurantIdTicket = respuestaServidor[0]["restaurant"]["id"].intValue
                    self.ticket = respuestaServidor[0]["ticket"].intValue
                    let dateTemp = respuestaServidor[0]["created"].stringValue
                    self.dateTicket = dateTemp.substringWithRange(0, end: 10)
                }
                print("ticket:\(respuestaServidor[c])")
                var fecha = respuestaServidor[c]["created"].stringValue
                fecha = fecha.substringWithRange(0, end: 10)
                let restaurant = respuestaServidor[c]["restaurant"]["nombre"].stringValue
                self.restauranteID.append(respuestaServidor[c]["restaurant"]["id"].stringValue)
                self.comandas.append(respuestaServidor[c]["comanda"].stringValue)
                self.tickets.append("\(fecha) \(restaurant)")
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.historialTableView.reloadData()
                self.progressBarDisplayer("Descargando", false)
                if self.pollStatus && self.ticketStatus == 5 {
                    self.performSegueWithIdentifier("pollSegue", sender: self)
                }
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "historialDetalleSegue") {
            let vc : DetailedTicketViewController = segue.destinationViewController as! DetailedTicketViewController
         
            vc.RestauranteID = self.restauranteID[idSelected]
            vc.comandaAnterior = self.comandas[idSelected]
            print("menu enviado: \(self.comandas[idSelected])")
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
        if(segue.identifier == "pollSegue") {
            let vc : PollViewController = segue.destinationViewController as! PollViewController
            vc.restaurantNombreTicket = restaurantNombreTicket
            vc.restaurantIdTicket = restaurantIdTicket
            vc.ticket = ticket
            vc.dateTicket = dateTicket
            vc.token = token
        }
    }
    override func viewWillAppear(animated: Bool) {
        updateTable()
    }
}
