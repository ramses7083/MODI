//
//  PerfilViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 26/11/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidosTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var diaPickerView: UIPickerView!
    @IBOutlet weak var mesPickerView: UIPickerView!
    @IBOutlet weak var añoPickerView: UIPickerView!
    @IBOutlet weak var generoPickerView: UIPickerView!
    var profileImage : UIImage!
    var token = ""
    var perfil: [String] = ["","","","","","",""]
    var databasePath = NSString()
    var dia = "01"
    var mes = "01"
    var año = "2006"
    var genero = "sin especificar"
    let diasPickerData = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    let diasNumericoPickerData = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    let mesPickerData = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    let mesNumericoPickerData = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    let añoPickerData = ["2006","2005","2004","2003","2002","2001","2000","1999","1998","1997","1996","1995","1994","1993","1992","1991","1990","1989","1988","1987","1986","1985","1984","1983","1982","1981","1980","1979","1978","1977","1976","1975","1974","1973","1972","1971","1970","1969","1968","1967","1966","1965","1964","1963","1962","1961","1960","1959","1958","1957","1956","1955","1954","1953","1952","1951","1950","1949","1948","1947","1946","1945","1944","1943","1942","1941","1940","1939","1938","1937","1936","1935","1934","1933","1932","1931","1930","1929","1928","1927","1926","1925","1924","1923","1922","1921","1920"]
    let generoPickerData = ["sin especificar", "femenino", "masculino"]
    var añoCont = 0
    var mesCont = 0
    var diaCont = 0
    var generoCont = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ProfileImageView.image = profileImage
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.clipsToBounds = true
        self.ProfileImageView.layer.borderWidth = 1.5
        self.ProfileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        
        //Asignar delegates
        diaPickerView.delegate = self
        diaPickerView.dataSource = self
        diaPickerView.tag = 0
        mesPickerView.delegate = self
        mesPickerView.dataSource = self
        mesPickerView.tag = 1
        añoPickerView.delegate = self
        añoPickerView.dataSource = self
        añoPickerView.tag = 2
        generoPickerView.delegate = self
        generoPickerView.dataSource = self
        generoPickerView.tag = 3
        nombreTextField.delegate = self
        apellidosTextField.delegate = self
        emailTextField.delegate = self
        
        //Diseño del textfield
        let width = CGFloat(0.7)
        let nombreBorderBottom = CALayer()
        nombreBorderBottom.borderColor = UIColor.blackColor().CGColor
        nombreBorderBottom.frame = CGRect(x: 0, y: nombreTextField.frame.size.height - width - 1, width:  nombreTextField.frame.size.width, height: 1.4)
        nombreBorderBottom.borderWidth = width
        let apellidosBorderBottom = CALayer()
        apellidosBorderBottom.borderColor = UIColor.blackColor().CGColor
        apellidosBorderBottom.frame = CGRect(x: 0, y: apellidosTextField.frame.size.height - width - 1, width:  apellidosTextField.frame.size.width, height: 1.4)
        apellidosBorderBottom.borderWidth = width
        let emailBorderBottom = CALayer()
        emailBorderBottom.borderColor = UIColor.blackColor().CGColor
        emailBorderBottom.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width - 1, width:  emailTextField.frame.size.width, height: 1.4)
        emailBorderBottom.borderWidth = width
        
        nombreTextField.layer.addSublayer(nombreBorderBottom)
        apellidosTextField.layer.addSublayer(apellidosBorderBottom)
        emailTextField.layer.addSublayer(emailBorderBottom)
        
        let result = ConnectDB().getProfileData(token)
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
                    self.perfil[0] = responseDictionary["first_name"]! as! String
                    self.perfil[1] = responseDictionary["last_name"]! as! String
                    self.perfil[2] = responseDictionary["email"]! as! String
                    self.perfil[6] = responseDictionary["gender"]! as! String
                    let birthdate = responseDictionary["birthdate"]! as! String
                    
                    if birthdate != "" {
                        let datosBirthdate = birthdate.componentsSeparatedByString("-")
                        self.perfil[5] = datosBirthdate[0]
                        self.perfil[4] = datosBirthdate[1]
                        self.perfil[3] = datosBirthdate[2]
                        for var c = 0; c < self.añoPickerData.count; c++ {
                            if self.perfil[5] == self.añoPickerData[c] {
                                self.añoCont = c
                                break
                            }
                        }
                        for var c = 0; c < self.mesNumericoPickerData.count; c++ {
                            if self.perfil[4] == self.mesNumericoPickerData[c] {
                                self.mesCont = c
                                break
                            }
                        }
                        for var c = 0; c < self.diasNumericoPickerData.count; c++ {
                            if self.perfil[3] == self.diasNumericoPickerData[c] {
                                self.diaCont = c
                                break
                            }
                        }
                        for var c = 0; c < self.generoPickerData.count; c++ {
                            if self.perfil[6] == self.generoPickerData[c] {
                                self.generoCont = c
                                break
                            }
                        }
                    }
                    
                    // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                    //
                    dispatch_async(dispatch_get_main_queue()) {
                        //     // update your UI and model objects here
                        self.nombreTextField.text = self.perfil[0]
                        self.apellidosTextField.text = self.perfil[1]
                        self.emailTextField.text = self.perfil[2]
                        self.diaPickerView.selectRow(self.diaCont, inComponent: 0, animated: true)
                        self.mesPickerView.selectRow(self.mesCont, inComponent: 0, animated: true)
                        self.añoPickerView.selectRow(self.añoCont, inComponent: 0, animated: true)
                        self.generoPickerView.selectRow(self.generoCont, inComponent: 0, animated: true)
                    }
                    
                    
                }
            } catch {
                print(error)
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }

        }
        task.resume()
        

        // Do any additional setup after loading the view.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return diasPickerData.count
        } else if pickerView.tag == 1 {
            return mesPickerData.count
        } else if pickerView.tag == 2 {
            return añoPickerData.count
        } else if pickerView.tag == 3 {
            return generoPickerData.count
        }
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return diasPickerData[row]
        } else if pickerView.tag == 1 {
            return mesPickerData[row]
        } else if pickerView.tag == 2 {
            return añoPickerData[row]
        } else if pickerView.tag == 3 {
            return generoPickerData[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            dia = diasNumericoPickerData[row]
            print("Dia: \(dia)")
            let result = ConnectDB().sendProfileData(token, nombre: "", apellidos: "", email: "", nacimiento: "\(año)-\(mes)-\(dia)", genero: "")
            sendRequest(result)
        } else if pickerView.tag == 1 {
            mes = mesNumericoPickerData[row]
            print("Mes: \(mes)")
            let result = ConnectDB().sendProfileData(token, nombre: "", apellidos: "", email: "", nacimiento: "\(año)-\(mes)-\(dia)", genero: "")
            sendRequest(result)
        } else if pickerView.tag == 2 {
            año = añoPickerData[row]
            print("Año: \(año)")
            let result = ConnectDB().sendProfileData(token, nombre: "", apellidos: "", email: "", nacimiento: "\(año)-\(mes)-\(dia)", genero: "")
            sendRequest(result)
        } else if pickerView.tag == 3 {
            genero = generoPickerData[row]
            print("Genero: \(genero)")
            let result = ConnectDB().sendProfileData(token, nombre: "", apellidos: "", email: "", nacimiento: "", genero: genero)
            sendRequest(result)
        }
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("termino de escribir")
        let result = ConnectDB().sendProfileData(token, nombre: nombreTextField.text!, apellidos: apellidosTextField.text!, email: emailTextField.text!, nacimiento: "", genero: "")
        sendRequest(result)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //print("presionó enter y termino de escribir")
        self.view.endEditing(true)
        return true
    }
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print("toco afuera y termino de escribir")
        self.view.endEditing(true)
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
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedRowText = NSMutableAttributedString()
        if pickerView.tag == 0 {
            attributedRowText = NSMutableAttributedString(string: diasPickerData[row])
            let attributedRowTextLength = attributedRowText.length
            attributedRowText.addAttribute(NSFontAttributeName, value: UIFont(name: "Bariol-regular", size: 9.0)!, range: NSRange(location: 0 ,length:attributedRowTextLength))
        }
        return attributedRowText
    }
    */

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
