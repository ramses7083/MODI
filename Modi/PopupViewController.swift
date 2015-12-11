//
//  PopupViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 22/11/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var rate1: UIButton!
    @IBOutlet weak var rate2: UIButton!
    @IBOutlet weak var rate3: UIButton!
    @IBOutlet weak var rate4: UIButton!
    @IBOutlet weak var rate5: UIButton!
    var evaluacion = 0
    var databasePath = NSString()
    var token = ""
    var RestauranteId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        
        let result = ConnectDB().getRestaurantRateByMe(token, idRestaurant: RestauranteId)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(result) { data, response, error in
            if error != nil {
                // handle error here
                print("Error al principio")
                print(error)
                return
            }
            
            // if response was JSON, then parse it
            let respuestaServidor = JSON(data: data!, options: [], error: nil)
            //print("resp:\(respuestaServidor)")
            dispatch_async(dispatch_get_main_queue()) {
                //     // update your UI and model objects here
                if respuestaServidor.count > 0 {
                    print("Fue evaluado alguna vez")
                    self.evaluacion = respuestaServidor[0]["rating"].intValue
                    print(self.evaluacion)
                    if self.evaluacion == 1 {
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate2.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate2.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                        self.rate3.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate3.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                        self.rate4.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate4.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                        self.rate5.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate5.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                    }
                    if self.evaluacion == 2 {
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate2.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate2.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate3.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate3.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                        self.rate4.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate4.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                        self.rate5.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate5.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                    }
                    if self.evaluacion == 3 {
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate2.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate2.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate3.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate3.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate4.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate4.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                        self.rate5.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate5.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                    }
                    if self.evaluacion == 4 {
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate2.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate2.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate3.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate3.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate4.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate4.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate5.setImage(UIImage(named: "rate-.png"), forState: .Normal)
                        self.rate5.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
                    }
                    if self.evaluacion == 5 {
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate2.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate2.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate3.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate3.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate4.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate4.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                        self.rate5.setImage(UIImage(named: "rate+.png"), forState: .Normal)
                        self.rate5.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
                    }
                }
                
                
            }
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

        // Do any additional setup after loading the view.
    }

    @IBAction func rate1Action(sender: AnyObject) {
        evaluacion = 1
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate2.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate2.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        rate3.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate3.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        rate4.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate4.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        rate5.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate5.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func rate2Action(sender: AnyObject) {
        evaluacion = 2
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate2.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate2.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate3.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate3.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        rate4.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate4.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        rate5.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate5.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func rate3Action(sender: AnyObject) {
        evaluacion = 3
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate2.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate2.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate3.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate3.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate4.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate4.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        rate5.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate5.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func rate4Action(sender: AnyObject) {
        evaluacion = 4
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate2.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate2.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate3.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate3.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate4.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate4.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate5.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        rate5.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func rate5Action(sender: AnyObject) {
        evaluacion = 5
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate1.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate2.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate2.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate3.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate3.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate4.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate4.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        rate5.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        rate5.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
    }
    override func viewWillDisappear(animated: Bool) {
        print("Evaluación: \(evaluacion)")
        if evaluacion > 0 {
            let result = ConnectDB().sendRestaurantRateByMe(token, idRestaurant: RestauranteId, rate: "\(evaluacion)")
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
