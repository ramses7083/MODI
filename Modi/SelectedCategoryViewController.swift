//
//  SelectedCategoryViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 18/09/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class SelectedCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var RestaurantImageView: UIImageView!
    @IBOutlet weak var CategoryTableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    var databasePath = NSString()
    var categoria: String = "categoria"
    let cellColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    var menu : JSON!
    var RestauranteID = ""
    var selected : Int!
    var imagen : UIImage!
    var idAlimento : Int!
    var idSelected : Int!
    var restaurantActivo : Double!
    var qrActivo = false
    var alert = UIAlertController(title: "Listo!", message: "Tu selección fue agregada al pedido", preferredStyle: UIAlertControllerStyle.Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        print("dato:\(datosSesion[7])")
        restaurantActivo = datosSesion[7].doubleValue
        if restaurantActivo == Double(RestauranteID) {
            qrActivo = true
        } else {
            qrActivo = false
        }
        //self.navigationItem.title = categoria
        categoryLabel.text = categoria
        RestaurantImageView.image = imagen
        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[selected]["articulos"].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! SelectedCategoryTableViewCell
        cell.FoodLabel?.text = menu[selected]["articulos"][indexPath.row]["descripcion"].stringValue
        if qrActivo { cell.plusButton.hidden = false }
        else { cell.plusButton.hidden = true }
        cell.plusButton.tag = indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.plusButton.addTarget(self, action: "foodSelected:", forControlEvents: .TouchUpInside)
        if (indexPath.row%2 != 0 ){
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
        print("Seleccionaste la comida #\(indexPath.row)!")
        idSelected = indexPath.row
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("FoodDetailSegue", sender: self)
        })
    }
    
    @IBAction func foodSelected(sender: UIButton) {
        let nombreAlimento = menu[selected]["articulos"][sender.tag]["descripcion"].stringValue
        let precioAlimento = menu[selected]["articulos"][sender.tag]["precio"].doubleValue
        let idAlimento = menu[selected]["articulos"][sender.tag]["idplatillo"].intValue
        ConnectDB().addProduct(databasePath, ProductId: idAlimento, ProductName: nombreAlimento, Amount: precioAlimento, Comment: "")
        print("Comida agregada con tag: \(sender.tag), de nombre:\(nombreAlimento), precio:\(precioAlimento), id:\(idAlimento)")
        //self.presentViewController(alert, animated: true, completion: nil)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("dismissAlert"), userInfo: nil, repeats: false)
        
        let optionAlert = UIAlertController(title: "Producto agregado", message: "¿Deseas seguir agregando productos a tu carrito o ver tu carrito?", preferredStyle: UIAlertControllerStyle.Alert)
        
        optionAlert.addAction(UIAlertAction(title: "Seguir agregando", style: .Default, handler: { (action: UIAlertAction) in
            print("Seleccionó seguir agregando")
        }))
        
        optionAlert.addAction(UIAlertAction(title: "Ver carrito", style: .Default, handler: { (action: UIAlertAction) in
            print("Selecciono ver el carrito")
            self.tabBarController?.selectedIndex = 3
        }))
        
        presentViewController(optionAlert, animated: true, completion: nil)
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
    func dismissAlert()
    {
        // Dismiss the alert from here
        alert.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "FoodDetailSegue") {
            let vc : FoodDetailViewController = segue.destinationViewController as! FoodDetailViewController
            vc.idSelected = idSelected
            vc.idCategory = selected
            vc.menu = menu
            vc.imagen = imagen
            vc.RestauranteID = RestauranteID
            let backItem = UIBarButtonItem()
            backItem.title = "Regresar"
            navigationItem.backBarButtonItem = backItem
        }
    }


}
