//
//  ProfileViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 05/05/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ProfileHeaderView: UIView!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var ProfileTableView: UITableView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var WelcomeMessageLabel: UILabel!
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    var databasePath = NSString()
    // Crear Array de los datos de la tabla
    var CellNames: [String] = ["Perfil", "Historial", "Cerrar sesión"]
    var IconImages: [String] = ["Perfil.png", "Historial.png", "cerrarSesion.png"]
    let cellColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    var userName = ""
    var profileImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion : NSArray = connectDB.checkSession(self.databasePath as String)
        print("Nombre: \(datosSesion[1]) url: \(datosSesion[4])")
        userName = datosSesion[1] as! String
        // Editar ImageView
                
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let imagePath = paths.stringByAppendingPathComponent("ProfileImage.png" )
        
        //Revisar que la imagen se guardo
        let checkImage = NSFileManager.defaultManager()
        if (checkImage.fileExistsAtPath(imagePath)) {
            print("Existe imagen")
            // Imprimir la imagen de perfil
            self.ProfileImageView.image = UIImage(contentsOfFile: imagePath)
            profileImage = UIImage(contentsOfFile: imagePath)
        } else {
            print("NO existe imagen de redes")
            self.ProfileImageView.image = UIImage(named: "usuario.png")
            profileImage = UIImage(named: "usuario.png")
        }
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.clipsToBounds = true
        self.ProfileImageView.layer.borderWidth = 1.5
        self.ProfileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.UserNameLabel.text = (userName)
      
        // Editar estilo del header
        /*self.UserNameLabel.text = (userName)
        self.navigationItem.title = ""
        let headerColor = UIColor(red: 51.0/255.0, green: 0.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = headerColor
        self.ProfileHeaderView.tag = 100
        self.navigationController?.navigationBar.addSubview(self.ProfileHeaderView)*/
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileTableViewCell
        if userName != "guest" || indexPath.row == 2 {
            cell.IconImageView.image = UIImage(named: IconImages[indexPath.row])
            cell.CellNameLabel.text? = CellNames[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        } else {
            cell.IconImageView.image = UIImage(named: IconImages[indexPath.row])
            cell.CellNameLabel.textColor = UIColor.grayColor()
            cell.CellNameLabel.text? = CellNames[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.userInteractionEnabled = false
        }
        
        
        if (indexPath.row%2 != 0 ){
            cell.backgroundColor = cellColor
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        cell.tag = indexPath.row
        print(cell.tag)
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            self.performSegueWithIdentifier("perfilSegue", sender: self)
        }
        if (indexPath.row == 1) {
            self.performSegueWithIdentifier("historialSegue", sender: self)
        }
        if (indexPath.row == 2) {
            progressBarDisplayer("Cerrando", true)
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            let imagePath = paths.stringByAppendingPathComponent("ProfileImage.png" )
            // Create a FileManager instance
            let fileManager = NSFileManager.defaultManager()
            
            // Delete file
            do {
                try fileManager.removeItemAtPath(imagePath)
            }
            catch let error as NSError {
                print("No se borro: \(error)")
            }
            ConnectDB().closeSession(self.databasePath as String)
            self.performSegueWithIdentifier("LogOutSegue", sender: self)
        }
        
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
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        print("Entro a viewWillAppear")
        self.UserNameLabel.hidden = false
        self.WelcomeMessageLabel.hidden = false
    }
    override func viewWillDisappear(animated: Bool) {
        print("Entro a viewWillDisappear")
        self.UserNameLabel.hidden = true
        self.WelcomeMessageLabel.hidden = true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "historialSegue") {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
        if(segue.identifier == "perfilSegue") {
            let vc : PerfilViewController = segue.destinationViewController as! PerfilViewController
            vc.profileImage = profileImage
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
        
    }


}
