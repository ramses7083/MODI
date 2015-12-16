//
//  FoodDetailViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 10/06/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var especificationsTextField: UITextField!
    @IBOutlet weak var FoodDescriptionLabel: UILabel!
    @IBOutlet weak var FoodPriceLabel: UILabel!
    @IBOutlet weak var FoodPriceTime: UILabel!
    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var FoodImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var lessProduct: UIButton!
    @IBOutlet weak var moreProduct: UIButton!
    @IBOutlet weak var addProduct: UIButton!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var especificationsLabel: UILabel!
    var cantidad = 1
    var idSelected : Int!
    var idCategory : Int!
    var idPlatillo : String!
    var amount : Double!
    var urlImagen : String!
    var menu : JSON!
    var imageCache = [String:UIImage]()
    var imagen : UIImage!
    var databasePath = NSString()
    var restaurantActivo : Double!
    var qrActivo = false
    var RestauranteID = ""
    var alert = UIAlertController(title: "Listo!", message: "Tu selección fue agregada al pedido", preferredStyle: UIAlertControllerStyle.Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerColor = UIColor(red: 223.0/255.0, green: 55.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = headerColor
        
        especificationsTextField.delegate = self
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        print("dato:\(datosSesion[7])")
        restaurantActivo = datosSesion[7].doubleValue
        if restaurantActivo == Double(RestauranteID) {
            especificationsTextField.hidden = false
            lessProduct.hidden = false
            moreProduct.hidden = false
            addProduct.hidden = false
            countLabel.hidden = false
            cantidadLabel.hidden = false
            especificationsLabel.hidden = false
        } else {
            especificationsTextField.hidden = true
            lessProduct.hidden = true
            moreProduct.hidden = true
            addProduct.hidden = true
            countLabel.hidden = true
            cantidadLabel.hidden = true
            especificationsLabel.hidden = true
        }
        
        // Do any additional setup after loading the view.
        print(menu[idCategory]["articulos"][idSelected])
        //self.navigationItem.title = "Detalles"
        FoodNameLabel.text = menu[idCategory]["articulos"][idSelected]["descripcion"].stringValue
        FoodDescriptionLabel.text = menu[idCategory]["articulos"][idSelected]["detalles"].stringValue
        FoodPriceLabel.text = "Precio: \(menu[idCategory]["articulos"][idSelected]["precio"])"
        FoodPriceTime.text = "Tiempo de preparación: \(menu[idCategory]["articulos"][idSelected]["tiempoPreparacion"]) minutos"
        idPlatillo = menu[idCategory]["articulos"][idSelected]["idplatillo"].stringValue
        urlImagen = menu[idCategory]["articulos"][idSelected]["nombre_imagen"].stringValue
        amount = menu[idCategory]["articulos"][idSelected]["precio"].doubleValue
        
        //Descargar imagen
        if urlImagen != "" {
            let urlString = "http://modi.mx/media/menu/\(urlImagen)"
            let imgURL = NSURL(string: urlString)
            if let img = imageCache[urlString] {
                self.FoodImageView.image = img
            } else {
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
                            self.FoodImageView.image = image
                        })
                    }
                    else {
                        print("Error: \(error!.localizedDescription)")
                    }
                })
            }
        } else {
            FoodImageView.image = imagen
        }

        // Diseño de UsuarioTextField
        let UsuarioBorderBottom = CALayer()
        let UsuarioBorderLeft = CALayer()
        let UsuarioBorderRight = CALayer()
        let width = CGFloat(1.4)
        UsuarioBorderLeft.borderColor = UIColor.lightGrayColor().CGColor
        UsuarioBorderLeft.frame = CGRect(x: 0, y: 22, width:  1.4, height: 6)
        UsuarioBorderRight.borderColor = UIColor.greenColor().CGColor
        UsuarioBorderRight.frame = CGRect(x: especificationsTextField.frame.size.width - 1.4, y: 22, width:  1.4, height: 6)
        UsuarioBorderBottom.borderColor = UIColor.greenColor().CGColor
        UsuarioBorderBottom.frame = CGRect(x: 0, y: especificationsTextField.frame.size.height - width - 1, width:  especificationsTextField.frame.size.width, height: 1.4)
        UsuarioBorderBottom.borderWidth = width
        UsuarioBorderLeft.borderWidth = width
        UsuarioBorderRight.borderWidth = width
        especificationsTextField.layer.addSublayer(UsuarioBorderBottom)
        especificationsTextField.layer.addSublayer(UsuarioBorderLeft)
        especificationsTextField.layer.addSublayer(UsuarioBorderRight)
        especificationsTextField.layer.masksToBounds = true
        let UsuarioPaddingView = UIView(frame: CGRectMake(0, 0, 10, self.especificationsTextField.frame.height))
        especificationsTextField.leftView = UsuarioPaddingView
        especificationsTextField.leftViewMode = UITextFieldViewMode.Always
        especificationsTextField.addTarget(self, action: "textFieldShouldReturn:", forControlEvents: .EditingDidEndOnExit)
        especificationsTextField.autocorrectionType = UITextAutocorrectionType.No
        
    }

    @IBAction func moreProduct(sender: AnyObject) {
        if (cantidad < 100) {
            cantidad += 1
            countLabel.text = "\(cantidad)"
        }
    }
    @IBAction func lessProduct(sender: AnyObject) {
        if (cantidad > 1) {
            cantidad -= 1
            countLabel.text = "\(cantidad)"
        }
    }
    @IBAction func AddFood(sender: AnyObject) {
        
        
        // Agregar el producto a SQLite
        for var c = 0 ; c < cantidad; c++ {
            ConnectDB().addProduct(databasePath, ProductId: Int(idPlatillo)!, ProductName: self.FoodNameLabel.text!, Amount: amount, Comment: self.especificationsTextField.text!)
        }
        

        let optionAlert = UIAlertController(title: "Producto agregado", message: "¿Deseas seguir agregando productos a tu carrito o ver tu carrito?", preferredStyle: UIAlertControllerStyle.Alert)
        
        optionAlert.addAction(UIAlertAction(title: "Seguir agregando", style: .Default, handler: { (action: UIAlertAction) in
            print("Seleccionó seguir agregando")
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        optionAlert.addAction(UIAlertAction(title: "Ver carrito", style: .Default, handler: { (action: UIAlertAction) in
            print("Selecciono ver el carrito")
            self.tabBarController?.selectedIndex = 3
        }))
        presentViewController(optionAlert, animated: true, completion: nil)
        //self.presentViewController(alert, animated: true, completion: nil)
        //NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("dismissAlert"), userInfo: nil, repeats: false)
    }
    
    func dismissAlert()
    {
        // Dismiss the alert from here
        alert.dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.especificationsTextField {
            self.view.endEditing(true)
        }
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 114)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 114)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
