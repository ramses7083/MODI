//
//  ViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 05/05/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Fabric
import TwitterKit
//G+
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GPPSignInDelegate, UITextFieldDelegate  {
    
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var FacebookButton: UIButton!
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var InvitadoButton: UIButton!
    @IBOutlet weak var IdentificarButton: UIButton!
    @IBOutlet weak var RegistrarseButton: UIButton!
    @IBOutlet weak var UsuarioTextField: UITextField!
    @IBOutlet weak var ContrasenaTextField: UITextField!
    var databasePath = NSString()
    var token = ""
    var fechaActual : String!
    var signIn : GPPSignIn?
    var responseDictionary : NSDictionary!
    var id = ""
    var nombre = ""
    var email = ""
    var urlImage = ""
    var invitado = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configurar TabBar
        //UITabBarItem.appearance().enabled = false
        
        //Obtener fecha
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm";
        fechaActual = dateFormatter.stringFromDate(date)
        
        //Se agrega self al delegate de los text field
        self.UsuarioTextField.delegate = self
        self.ContrasenaTextField.delegate = self
        
        // Inicio de sesion de Facebook
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in..")
        }
        else
        {
            print("Logged in..")
        }
        
        // Inicio de sesion de Google+
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.clientID = "220909684439-akoj0ilagevb31ampudo425suevherh9.apps.googleusercontent.com"
        signIn?.scopes = [kGTLAuthScopePlusLogin]
        signIn?.delegate = self
        signIn?.signOut()
        
        var prueba = Array(count:2, repeatedValue:Array(count:3, repeatedValue:String()))
        prueba[0][0]="hola"
        prueba[0][2]="tu"
        
        //var prueba: Array<Array<String>>!
        //prueba[0][0] = "hola"
        //print("Valor de array: \(prueba[0][0]) \(prueba[0][2])")
        
        // Editar el diseño de los UITextField
        
        
        // Diseño de UsuarioTextField
        let UsuarioBorderBottom = CALayer()
        let UsuarioBorderLeft = CALayer()
        let UsuarioBorderRight = CALayer()
        let width = CGFloat(1.4)
        UsuarioBorderLeft.borderColor = UIColor.whiteColor().CGColor
        UsuarioBorderLeft.frame = CGRect(x: 0, y: 22, width:  1.4, height: 6)
        UsuarioBorderRight.borderColor = UIColor.whiteColor().CGColor
        UsuarioBorderRight.frame = CGRect(x: UsuarioTextField.frame.size.width - 1.4, y: 22, width:  1.4, height: 6)
        UsuarioBorderBottom.borderColor = UIColor.whiteColor().CGColor
        UsuarioBorderBottom.frame = CGRect(x: 0, y: UsuarioTextField.frame.size.height - width - 1, width:  UsuarioTextField.frame.size.width, height: 1.4)
        UsuarioBorderBottom.borderWidth = width
        UsuarioBorderLeft.borderWidth = width
        UsuarioBorderRight.borderWidth = width
        UsuarioTextField.layer.addSublayer(UsuarioBorderBottom)
        UsuarioTextField.layer.addSublayer(UsuarioBorderLeft)
        UsuarioTextField.layer.addSublayer(UsuarioBorderRight)
        UsuarioTextField.layer.masksToBounds = true
        let UsuarioPaddingView = UIView(frame: CGRectMake(0, 0, 10, self.UsuarioTextField.frame.height))
        UsuarioTextField.leftView = UsuarioPaddingView
        UsuarioTextField.leftViewMode = UITextFieldViewMode.Always
        UsuarioTextField.font = UIFont(name: "BariolRegular", size: 19)
        UsuarioTextField.attributedPlaceholder = NSAttributedString(string:"usuario", attributes:[NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont(name: "BariolRegular-Italic", size: 19)!])
        //UsuarioTextField.addTarget(self, action: "textFieldShouldReturn:", forControlEvents: .EditingDidEndOnExit)
        UsuarioTextField.autocorrectionType = UITextAutocorrectionType.No
        
        // Diseño de ContrasenaTextField
        let ContrasenaBorderBottom = CALayer()
        let ContrasenaBorderLeft = CALayer()
        let ContrasenaBorderRight = CALayer()
        ContrasenaBorderLeft.borderColor = UIColor.whiteColor().CGColor
        ContrasenaBorderLeft.frame = CGRect(x: 0, y: 22, width:  1.4, height: 6)
        ContrasenaBorderRight.borderColor = UIColor.whiteColor().CGColor
        ContrasenaBorderRight.frame = CGRect(x: ContrasenaTextField.frame.size.width - 1.4, y: 22, width:  1.4, height: 6)
        ContrasenaBorderBottom.borderColor = UIColor.whiteColor().CGColor
        ContrasenaBorderBottom.frame = CGRect(x: 0, y: ContrasenaTextField.frame.size.height - width - 1, width:  UsuarioTextField.frame.size.width, height: 1.4)
        ContrasenaBorderBottom.borderWidth = width
        ContrasenaBorderLeft.borderWidth = width
        ContrasenaBorderRight.borderWidth = width
        ContrasenaTextField.layer.addSublayer(ContrasenaBorderBottom)
        ContrasenaTextField.layer.addSublayer(ContrasenaBorderLeft)
        ContrasenaTextField.layer.addSublayer(ContrasenaBorderRight)
        UsuarioTextField.layer.masksToBounds = true
        let ContrasenaPaddingView = UIView(frame: CGRectMake(0, 0, 10, self.ContrasenaTextField.frame.height))
        ContrasenaTextField.leftView = ContrasenaPaddingView
        ContrasenaTextField.leftViewMode = UITextFieldViewMode.Always
        ContrasenaTextField.font = UIFont(name: "BariolRegular", size: 19)
        ContrasenaTextField.attributedPlaceholder = NSAttributedString(string:"contraseña", attributes:[NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont(name: "BariolRegular-Italic", size: 19)!])
        ContrasenaTextField.autocorrectionType = UITextAutocorrectionType.No
        ContrasenaTextField.returnKeyType = .Done
        //ContrasenaTextField.addTarget(self, action: "LogInAction:", forControlEvents: .EditingDidEndOnExit)
        
        // Diseño de IdentificarButton
        IdentificarButton.layer.borderWidth = 1.4
        IdentificarButton.layer.borderColor = UIColor.whiteColor().CGColor
        //RegistrarseButton.layer.borderWidth = 1.4
        //RegistrarseButton.layer.borderColor = UIColor.whiteColor().CGColor
        //InvitadoButton.layer.borderWidth = 1.4
        //InvitadoButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        connectDB.cleanOrder(self.databasePath as String)
        connectDB.updateRestaurant(self.databasePath, idRestaurant: 0, idMesa: 0)
        let datosSesion = connectDB.checkSession(databasePath as String)
        if datosSesion[1] as! String == "guest" {
            connectDB.closeSession(databasePath as String)
            
        } else {
            token = datosSesion[6] as! String
            if token != "false" {
                if datosSesion[1] as! String == "guest" { invitado = true }
                progressBarDisplayer("Iniciando sesión", true)
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("LoginSegue", sender: self)
                }
                
            }
        }
        
        
        //Ocultar UIActivity
        ActivityIndicator.hidden = true
        
        //Imprimir las fuentes disponibles
        /*
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName )
            print("Font Names = [\(names)]")
        }
        */
        
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
    @IBAction func LogInAction(sender: AnyObject) {
        /*ActivityIndicator.hidden = false
        ActivityIndicator.startAnimating()*/
        progressBarDisplayer("Iniciando", true)
        let connectDB = ConnectDB()
        //connectDB.addSession(databasePath, id: 1, nombre: UsuarioTextField.text, fecha: "2013-06-02")
        connectDB.checkSession(databasePath as String)
        
        //Iniciar sesión con cuenta de modi
        if UsuarioTextField.text != "" && ContrasenaTextField.text != "" {
            let result = ConnectDB().loginModi(UsuarioTextField.text!, password: ContrasenaTextField.text!)
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
                            //print("Respuesta del servidor: \(result)")
                            let responseCheck = responseDictionary["token"]
                            print(responseCheck)
                            if responseDictionary["token"] != nil {
                                print("tokennnn: \(responseDictionary["token"]!)")
                                self.token = "\(responseDictionary["token"]!)"
                                connectDB.addSession(self.databasePath, id: "1", nombre: self.UsuarioTextField.text!, fecha: self.fechaActual, imagen: "usuario.png", tipo: "modi", token:"\(responseDictionary["token"]!)")
                                //ConnectDB().updateRestaurant(self.databasePath, idRestaurant: 1, idMesa: 1)
                                print("Login: \(responseDictionary["token"]!.stringValue)")
                                self.performSegueWithIdentifier("LoginSegue", sender: self)
                            } else {
                                self.progressBarDisplayer("Iniciando", false)
                                self.ContrasenaTextField.text = ""
                                /*self.ActivityIndicator.hidden = true
                                self.ActivityIndicator.stopAnimating()*/
                                print("Usuario incorrecto")
                                let optionAlert = UIAlertController(title: "Error", message: "Los datos que ingresaste son incorrectos", preferredStyle: UIAlertControllerStyle.Alert)
                                optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                                }))
                                self.presentViewController(optionAlert, animated: true, completion: nil)
                            }
                            
                            
                        }
                        
                        
                    }
                } catch {
                    print(error)
                    
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("responseString = \(responseString)")
                }
            }
            task.resume()
            
            
            
        } else {
            print("Datos para registro incompletos")
            let optionAlert = UIAlertController(title: "Datos incompletos", message: "Completa todos los campos", preferredStyle: UIAlertControllerStyle.Alert)
            optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
            }))
            presentViewController(optionAlert, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Facebook Login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            print("Login complete.")
            //progressBarDisplayer("Iniciando", true)
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User logged out...")
    }

    @IBAction func FacebookButton(sender: AnyObject) {
        print("Boton de facebook")
        self.progressBarDisplayer("Esperando", true)
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                //self.ActivityIndicator.startAnimating()
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
        
    }
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil){
                    self.progressBarDisplayer("Esperando", true)
                    self.progressBarDisplayer("Iniciando sesión", true)
                    print(result)
                    self.id = result["id"] as! String
                    self.nombre = result["name"] as! String
                    self.email = result["email"] as! String
                    print("El email de facebook es: \(self.email)")
                    self.urlImage = "https://graph.facebook.com/\(self.id)/picture?width=200&height=200"
                    print("\(self.id)\(self.nombre)\(self.urlImage)")
                    let connectDB = ConnectDB()
                    // REGISTRAR EN LA RED SOCIAL
                    let result = ConnectDB().registerNewUser(self.email, password: "passphrase.\(self.email).00", email: self.email)
                    //Generar consulta en el servidor
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
                                    //INICIAR CON LA RED SOCIAL
                                    let result = ConnectDB().loginModi(self.email, password: "passphrase.\(self.email).00")
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
                                                    //print("Respuesta del servidor: \(result)")
                                                    let responseCheck = responseDictionary["token"]
                                                    print(responseCheck)
                                                    if responseDictionary["token"] != nil {
                                                        print("tokennnn: \(responseDictionary["token"]!)")
                                                        self.token = "\(responseDictionary["token"]!)"
                                                        connectDB.addSession(self.databasePath, id: self.id, nombre: self.nombre, fecha: self.fechaActual, imagen: self.urlImage, tipo: "facebook", token:self.token)
                                                        print("Login: \(responseDictionary["token"]!.stringValue)")
                                                        // Guardar imagen
                                                        /*
                                                        let url = NSURL(string: self.urlImage)
                                                        let data:NSData = NSData(contentsOfURL: url!)!
                                                        let image = UIImage(data: data)
                                                        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                                                        let imagePath = paths.stringByAppendingPathComponent("ProfileImage.png" )
                                                        UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                                                        */
                                                        self.performSegueWithIdentifier("LoginSegue", sender: self)
                                                    } else {
                                                        self.progressBarDisplayer("Iniciando", false)
                                                        print("Error de login con Twitter")
                                                        let optionAlert = UIAlertController(title: "Error", message: "Servidor de Facebook no disponible para conexión", preferredStyle: UIAlertControllerStyle.Alert)
                                                        optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                                                        }))
                                                        self.presentViewController(optionAlert, animated: true, completion: nil)
                                                    }
                                                    
                                                    
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
                            }
                        } catch {
                            print(error)
                            
                            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("responseString = \(responseString)")
                        }
                    }
                    task.resume()
                    // FINALIZA EL INICIO CON LA RED SOCIAL
                }
            })
        } else {
            print("Variable de facebook es Nil")
        }
    }
    
    // MARK: - Twitter Login
    @IBAction func TwitterButton(sender: AnyObject) {
        print("Boton de Twitter")
        self.progressBarDisplayer("Iniciando sesión", true)
        Twitter.sharedInstance().logInWithCompletion{session, error in
            if session != nil {
                // Here you have a valid session you can use.
                //self.ActivityIndicator.startAnimating()
                self.id = session!.userID
                self.nombre = "@\(session!.userName)"
                //let email = ""
                self.urlImage = "https://twitter.com/\(session!.userName)/profile_image?size=original"
                print("id: \(self.id) username: \(self.nombre) urlImage: \(self.urlImage)")
                self.email = "\(session!.userName)@twitter.com"
                let connectDB = ConnectDB()
                
                // REGISTRAR EN LA RED SOCIAL
                print("email:\(self.email)")
                print("passphrase.\(self.email).00")
                let result = ConnectDB().registerNewUser(self.email, password: "passphrase.\(self.email).00", email: self.email)
                //Generar consulta en el servidor
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
                                //INICIAR CON LA RED SOCIAL
                                let result = ConnectDB().loginModi(self.email, password: "passphrase.\(self.email).00")
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
                                                //print("Respuesta del servidor: \(result)")
                                                let responseCheck = responseDictionary["token"]
                                                print(responseCheck)
                                                if responseDictionary["token"] != nil {
                                                    print("tokennnn: \(responseDictionary["token"]!)")
                                                    self.token = "\(responseDictionary["token"]!)"
                                                    connectDB.addSession(self.databasePath, id: self.id, nombre: self.nombre, fecha: self.fechaActual, imagen: self.urlImage, tipo: "twitter", token:self.token)
                                                    print("Login: \(responseDictionary["token"]!.stringValue)")
                                                    // Guardar imagen
                                                    /*
                                                    let url = NSURL(string: self.urlImage)
                                                    let data:NSData = NSData(contentsOfURL: url!)!
                                                    let image = UIImage(data: data)
                                                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                                                    let imagePath = paths.stringByAppendingPathComponent("ProfileImage.png" )
                                                    UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                                                    */
                                                    self.performSegueWithIdentifier("LoginSegue", sender: self)
                                                } else {
                                                    self.progressBarDisplayer("Iniciando", false)
                                                    print("Error de login con Twitter")
                                                    let optionAlert = UIAlertController(title: "Error", message: "Servidor de Twitter no disponible para conexión", preferredStyle: UIAlertControllerStyle.Alert)
                                                    optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                                                    }))
                                                    self.presentViewController(optionAlert, animated: true, completion: nil)
                                                }
                                                
                                                
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
                        }
                    } catch {
                        print(error)
                        
                        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("responseString = \(responseString)")
                    }
                }
                task.resume()
                // FINALIZA EL INICIO CON LA RED SOCIAL
                
            } else {
                self.progressBarDisplayer("Iniciando sesión", false)
                print("Error al iniciar sesion en Twitter: \(error)")
            }
        }
    }
    
    //MARK: G+
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        self.progressBarDisplayer("Esperando", false)
        self.progressBarDisplayer("Iniciando Sesión", true)
        signIn = GPPSignIn.sharedInstance()
        self.nombre = signIn!.googlePlusUser.displayName
        self.id = signIn!.googlePlusUser.identifier
        self.urlImage = signIn!.googlePlusUser.image.url
        let email = signIn!.googlePlusUser.emails.first!.JSON!["value"]!
        self.email = email as! String
        let connectDB = ConnectDB()
        print("GoogleUser: \(self.nombre) ID: \(self.id) email: \(self.email) Image: \(self.urlImage)")
        // REGISTRAR EN LA RED SOCIAL
        let result = ConnectDB().registerNewUser(self.email, password: "passphrase.\(self.email).00", email: self.email)
        //Generar consulta en el servidor
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
                        //INICIAR CON LA RED SOCIAL
                        let result = ConnectDB().loginModi(self.email, password: "passphrase.\(self.email).00")
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
                                        //print("Respuesta del servidor: \(result)")
                                        let responseCheck = responseDictionary["token"]
                                        print(responseCheck)
                                        if responseDictionary["token"] != nil {
                                            print("tokennnn: \(responseDictionary["token"]!)")
                                            self.token = "\(responseDictionary["token"]!)"
                                            connectDB.addSession(self.databasePath, id: self.id, nombre: self.nombre, fecha: self.fechaActual, imagen: self.urlImage, tipo: "google", token:self.token)
                                            print("Login: \(responseDictionary["token"]!.stringValue)")
                                            // Guardar imagen
                                            /*
                                            let url = NSURL(string: self.urlImage)
                                            let data:NSData = NSData(contentsOfURL: url!)!
                                            let image = UIImage(data: data)
                                            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                                            let imagePath = paths.stringByAppendingPathComponent("ProfileImage.png" )
                                            UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                                            */
                                            self.performSegueWithIdentifier("LoginSegue", sender: self)
                                        } else {
                                            self.progressBarDisplayer("Iniciando", false)
                                            print("Error de login con Google")
                                            let optionAlert = UIAlertController(title: "Error", message: "Servidor de Google no disponible para conexión", preferredStyle: UIAlertControllerStyle.Alert)
                                            optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                                            }))
                                            self.presentViewController(optionAlert, animated: true, completion: nil)
                                        }
                                        
                                        
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
                }
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
        }
        task.resume()
        // FINALIZA EL INICIO CON LA RED SOCIAL
    }
    @IBAction func InvitadoAction(sender: AnyObject) {
        invitado = true
        progressBarDisplayer("Iniciando sesión", true)
        let connectDB = ConnectDB()
        //connectDB.addSession(databasePath, id: 1, nombre: UsuarioTextField.text, fecha: "2013-06-02")
        connectDB.checkSession(databasePath as String)
        let result = ConnectDB().loginModi("guest", password: "92c141c3db225f013f21")
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
                        //print("Respuesta del servidor: \(result)")
                        let responseCheck = responseDictionary["token"]
                        print(responseCheck)
                        if responseDictionary["token"] != nil {
                            print("tokennnn: \(responseDictionary["token"]!)")
                            self.token = "\(responseDictionary["token"]!)"
                            connectDB.addSession(self.databasePath, id: "1", nombre: "guest", fecha: self.fechaActual, imagen: "usuario.png", tipo: "modi", token:"\(responseDictionary["token"]!)")
                            print("Login: \(responseDictionary["token"]!.stringValue)")
                            self.performSegueWithIdentifier("LoginSegue", sender: self)
                        } else {
                            self.progressBarDisplayer("Iniciando", false)
                            self.ContrasenaTextField.text = ""
                            /*self.ActivityIndicator.hidden = true
                            self.ActivityIndicator.stopAnimating()*/
                            print("Error al iniciar")
                            let optionAlert = UIAlertController(title: "Error", message: "El servidor no esta disponible en este momento", preferredStyle: UIAlertControllerStyle.Alert)
                            optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                            }))
                            self.presentViewController(optionAlert, animated: true, completion: nil)
                        }
                        
                        
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
    func didDisconnectWithError(error: NSError!) {
        
    }
    @IBAction func GoogleButton(sender: AnyObject) {
        self.progressBarDisplayer("Esperando", true)
         signIn?.authenticate()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.UsuarioTextField {
            ContrasenaTextField.becomeFirstResponder()
        }
     
        if textField == self.ContrasenaTextField {
            LogInAction(self)
            //self.view.endEditing(true)
        }
        return true
    }
    /*
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 30)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 30)
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
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "LoginSegue") {
            // No se puede hacer el siguiente procedimiento porque está conectado a un TabBar
            let vc : PrincipalTabBarViewController = segue.destinationViewController as! PrincipalTabBarViewController
            vc.invitado = invitado
        }
    }

}

