//
//  NewUserViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 27/10/15.
//  Copyright © 2015 RASOFT. All rights reserved.
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

class NewUserViewController: UIViewController, FBSDKLoginButtonDelegate, GPPSignInDelegate, UITextFieldDelegate {
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var FacebookButton: UIButton!
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var InvitadoButton: UIButton!
    @IBOutlet weak var RegistrarseButton: UIButton!
    @IBOutlet weak var YaTengoCuentaButton: UIButton!
    @IBOutlet weak var UsuarioTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var ContrasenaTextField: UITextField!
    @IBOutlet weak var RepetirContrasenaTextField: UITextField!
    var token = ""
    var fechaActual : String!
    var databasePath = NSString()
    var signIn : GPPSignIn?
    var id = ""
    var nombre = ""
    var email = ""
    var urlImage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configurar TabBar
        //UITabBarItem.appearance().enabled = false
        
        //Obtener fecha
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm";
        fechaActual = dateFormatter.stringFromDate(date)
        
        //Agregar self a los text field delegate
        self.UsuarioTextField.delegate = self
        self.EmailTextField.delegate = self
        self.ContrasenaTextField.delegate = self
        self.RepetirContrasenaTextField.delegate = self
        
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
        
        // Diseño de EmailTextField
        let EmailBorderBottom = CALayer()
        let EmailBorderLeft = CALayer()
        let EmailBorderRight = CALayer()
        EmailBorderLeft.borderColor = UIColor.whiteColor().CGColor
        EmailBorderLeft.frame = CGRect(x: 0, y: 22, width:  1.4, height: 6)
        EmailBorderRight.borderColor = UIColor.whiteColor().CGColor
        EmailBorderRight.frame = CGRect(x: EmailTextField.frame.size.width - 1.4, y: 22, width:  1.4, height: 6)
        EmailBorderBottom.borderColor = UIColor.whiteColor().CGColor
        EmailBorderBottom.frame = CGRect(x: 0, y: EmailTextField.frame.size.height - width - 1, width:  EmailTextField.frame.size.width, height: 1.4)
        EmailBorderBottom.borderWidth = width
        EmailBorderLeft.borderWidth = width
        EmailBorderRight.borderWidth = width
        EmailTextField.layer.addSublayer(EmailBorderBottom)
        EmailTextField.layer.addSublayer(EmailBorderLeft)
        EmailTextField.layer.addSublayer(EmailBorderRight)
        EmailTextField.layer.masksToBounds = true
        let EmailPaddingView = UIView(frame: CGRectMake(0, 0, 10, self.EmailTextField.frame.height))
        EmailTextField.leftView = EmailPaddingView
        EmailTextField.leftViewMode = UITextFieldViewMode.Always
        EmailTextField.font = UIFont(name: "BariolRegular", size: 19)
        EmailTextField.attributedPlaceholder = NSAttributedString(string:"e-mail", attributes:[NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont(name: "BariolRegular-Italic", size: 19)!])
        //EmailTextField.addTarget(self, action: "textFieldShouldReturn:", forControlEvents: .EditingDidEndOnExit)
        EmailTextField.autocorrectionType = UITextAutocorrectionType.No
        
        // Diseño de ContrasenaTextField
        let ContrasenaBorderBottom = CALayer()
        let ContrasenaBorderLeft = CALayer()
        let ContrasenaBorderRight = CALayer()
        ContrasenaBorderLeft.borderColor = UIColor.whiteColor().CGColor
        ContrasenaBorderLeft.frame = CGRect(x: 0, y: 22, width:  1.4, height: 6)
        ContrasenaBorderRight.borderColor = UIColor.whiteColor().CGColor
        ContrasenaBorderRight.frame = CGRect(x: ContrasenaTextField.frame.size.width - 1.4, y: 22, width:  1.4, height: 6)
        ContrasenaBorderBottom.borderColor = UIColor.whiteColor().CGColor
        ContrasenaBorderBottom.frame = CGRect(x: 0, y: ContrasenaTextField.frame.size.height - width - 1, width:  ContrasenaTextField.frame.size.width, height: 1.4)
        ContrasenaBorderBottom.borderWidth = width
        ContrasenaBorderLeft.borderWidth = width
        ContrasenaBorderRight.borderWidth = width
        ContrasenaTextField.layer.addSublayer(ContrasenaBorderBottom)
        ContrasenaTextField.layer.addSublayer(ContrasenaBorderLeft)
        ContrasenaTextField.layer.addSublayer(ContrasenaBorderRight)
        ContrasenaTextField.layer.masksToBounds = true
        let ContrasenaPaddingView = UIView(frame: CGRectMake(0, 0, 10, self.ContrasenaTextField.frame.height))
        ContrasenaTextField.leftView = ContrasenaPaddingView
        ContrasenaTextField.leftViewMode = UITextFieldViewMode.Always
        ContrasenaTextField.font = UIFont(name: "BariolRegular", size: 19)
        ContrasenaTextField.attributedPlaceholder = NSAttributedString(string:"contraseña", attributes:[NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont(name: "BariolRegular-Italic", size: 19)!])
        ContrasenaTextField.autocorrectionType = UITextAutocorrectionType.No
        
        // Diseño de RepetirContrasenaTextField
        let RepetirContrasenaBorderBottom = CALayer()
        let RepetirContrasenaBorderLeft = CALayer()
        let RepetirContrasenaBorderRight = CALayer()
        RepetirContrasenaBorderLeft.borderColor = UIColor.whiteColor().CGColor
        RepetirContrasenaBorderLeft.frame = CGRect(x: 0, y: 22, width:  1.4, height: 6)
        RepetirContrasenaBorderRight.borderColor = UIColor.whiteColor().CGColor
        RepetirContrasenaBorderRight.frame = CGRect(x: RepetirContrasenaTextField.frame.size.width - 1.4, y: 22, width:  1.4, height: 6)
        RepetirContrasenaBorderBottom.borderColor = UIColor.whiteColor().CGColor
        RepetirContrasenaBorderBottom.frame = CGRect(x: 0, y: RepetirContrasenaTextField.frame.size.height - width - 1, width:  RepetirContrasenaTextField.frame.size.width, height: 1.4)
        RepetirContrasenaBorderBottom.borderWidth = width
        RepetirContrasenaBorderLeft.borderWidth = width
        RepetirContrasenaBorderRight.borderWidth = width
        RepetirContrasenaTextField.layer.addSublayer(RepetirContrasenaBorderBottom)
        RepetirContrasenaTextField.layer.addSublayer(RepetirContrasenaBorderLeft)
        RepetirContrasenaTextField.layer.addSublayer(RepetirContrasenaBorderRight)
        RepetirContrasenaTextField.layer.masksToBounds = true
        let RepetirContrasenaPaddingView = UIView(frame: CGRectMake(0, 0, 10, self.RepetirContrasenaTextField.frame.height))
        RepetirContrasenaTextField.leftView = RepetirContrasenaPaddingView
        RepetirContrasenaTextField.leftViewMode = UITextFieldViewMode.Always
        RepetirContrasenaTextField.font = UIFont(name: "BariolRegular", size: 19)
        RepetirContrasenaTextField.attributedPlaceholder = NSAttributedString(string:"confirmar contraseña", attributes:[NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont(name: "BariolRegular-Italic", size: 19)!])
        RepetirContrasenaTextField.autocorrectionType = UITextAutocorrectionType.No
        RepetirContrasenaTextField.returnKeyType = .Done
        //ContrasenaTextField.addTarget(self, action: "iniciarSesion:", forControlEvents: .EditingDidEndOnExit)
        
        // Diseño de IdentificarButton
        RegistrarseButton.layer.borderWidth = 1.4
        RegistrarseButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        
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
        
        //Esconder uiactivity
        ActivityIndicator.hidden = true
        
    }
    
    @IBAction func RegistrationAction(sender: AnyObject) {
        if EmailTextField.text != "" && UsuarioTextField.text != "" && ContrasenaTextField.text != "" && RepetirContrasenaTextField.text != "" {
            if ContrasenaTextField.text == RepetirContrasenaTextField.text  {
                let result = ConnectDB().registerNewUser(UsuarioTextField.text!, password: ContrasenaTextField.text!, email: EmailTextField.text!)
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
                        let respuestaServidor2 = JSON(data: data!, options: [], error: nil)
                        print(respuestaServidor2)
                        if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                            print("success == \(responseDictionary)")
                            
                            // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                            //
                            dispatch_async(dispatch_get_main_queue()) {
                                //     // update your UI and model objects here
                                //print("Respuesta del servidor: \(result)")
                                if responseDictionary["id"] != nil {
                                    let optionAlert = UIAlertController(title: "Registro exitoso", message: "Ya puedes hacer uso de todas las funciones de MODI App!", preferredStyle: UIAlertControllerStyle.Alert)
                                    optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                                        self.performSegueWithIdentifier("inicioSegue", sender: self)
                                    }))
                                    self.presentViewController(optionAlert, animated: true, completion: nil)
                                } else {
                                    let optionAlert = UIAlertController(title: "Error en el registro", message: "Nombre de usuario no disponible, intenta de nuevo con uno diferente", preferredStyle: UIAlertControllerStyle.Alert)
                                    optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                                    }))
                                    self.presentViewController(optionAlert, animated: true, completion: nil)
                                    self.ContrasenaTextField.text = ""
                                    self.RepetirContrasenaTextField.text = ""
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
                print("Las contraseñas no coinciden")
                ContrasenaTextField.text = ""
                RepetirContrasenaTextField.text = ""
                let optionAlert = UIAlertController(title: "Error", message: "Las contraseñas no coinciden, intentalo de nuevo", preferredStyle: UIAlertControllerStyle.Alert)
                optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                }))
                
                presentViewController(optionAlert, animated: true, completion: nil)
            }
        } else {
            print("Datos para registro incompletos")
            let optionAlert = UIAlertController(title: "Datos incompletos", message: "Completa todos los campos del registro", preferredStyle: UIAlertControllerStyle.Alert)
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
            self.performSegueWithIdentifier("RegistroSegue", sender: self)
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
        self.progressBarDisplayer("Iniciando sesión", true)
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
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
                    print(result)
                    self.id = result["id"] as! String
                    self.nombre = result["name"] as! String
                    self.email = result["email"] as! String
                    print("El email de facebook es: \(self.email)")
                    self.urlImage = "https://graph.facebook.com/\(self.id)/picture?width=44&height=44"
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
                                                        let url = NSURL(string: self.urlImage)
                                                        let data:NSData = NSData(contentsOfURL: url!)!
                                                        let image = UIImage(data: data)
                                                        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                                                        let imagePath = paths.stringByAppendingPathComponent("ProfileImage.png" )
                                                        UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                                                        self.performSegueWithIdentifier("RegistroSegue", sender: self)
                                                    } else {
                                                        self.progressBarDisplayer("Descargando", false)
                                                        print("Error de login con Twitter")
                                                        let optionAlert = UIAlertController(title: "Error", message: "Servidor de Twiiter no disponible para conexión", preferredStyle: UIAlertControllerStyle.Alert)
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
                self.urlImage = "https://twitter.com/\(session!.userName)/profile_image?size=bigger"
                print("id: \(self.id) username: \(self.nombre) urlImage: \(self.urlImage)")
                self.email = "\(session!.userName)@twitter.com"
                let connectDB = ConnectDB()
                
                // REGISTRAR EN LA RED SOCIAL
                print("email:\(self.email)")
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
                                                    let url = NSURL(string: self.urlImage)
                                                    let data:NSData = NSData(contentsOfURL: url!)!
                                                    let image = UIImage(data: data)
                                                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                                                    let imagePath = paths.stringByAppendingPathComponent("ProfileImage.png" )
                                                    UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                                                    self.performSegueWithIdentifier("RegistroSegue", sender: self)
                                                } else {
                                                    self.progressBarDisplayer("Descargando", false)
                                                    print("Error de login con Twitter")
                                                    let optionAlert = UIAlertController(title: "Error", message: "Servidor de Twiiter no disponible para conexión", preferredStyle: UIAlertControllerStyle.Alert)
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
                print("Error al iniciar sesion en Twitter: \(error)")
            }
        }

    }
    
    //MARK: G+
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        self.progressBarDisplayer("Descargando", true)
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
                                            let url = NSURL(string: self.urlImage)
                                            let data:NSData = NSData(contentsOfURL: url!)!
                                            let image = UIImage(data: data)
                                            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                                            let imagePath = paths.stringByAppendingPathComponent("ProfileImage.png" )
                                            UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
                                            self.performSegueWithIdentifier("RegistroSegue", sender: self)
                                        } else {
                                            self.progressBarDisplayer("Descargando", false)
                                            print("Error de login con Twitter")
                                            let optionAlert = UIAlertController(title: "Error", message: "Servidor de Twiiter no disponible para conexión", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func didDisconnectWithError(error: NSError!) {
        
    }
    @IBAction func GoogleButton(sender: AnyObject) {
        self.progressBarDisplayer("Iniciando sesión", true)
        signIn?.authenticate()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.UsuarioTextField {
            EmailTextField.becomeFirstResponder()
        }
        if textField == self.EmailTextField {
            ContrasenaTextField.becomeFirstResponder()
        }
        if textField == self.ContrasenaTextField {
            RepetirContrasenaTextField.becomeFirstResponder()
        }
        if textField == self.RepetirContrasenaTextField {
            RegistrationAction(self)
        }
        return true
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
        if(segue.identifier == "RegistroSegue") {
            /*let vc : SearchViewController = segue.destinationViewController as! SearchViewController
            vc.token = token*/
        }
    }
}
