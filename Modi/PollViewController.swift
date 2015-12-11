//
//  PollViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 25/11/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class PollViewController: UIViewController, UITextViewDelegate {
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    @IBOutlet weak var dateTicketLabel: UILabel!
    @IBOutlet weak var restaurantTicketLabel: UILabel!
    @IBOutlet weak var evaluacion1Label: UILabel!
    @IBOutlet weak var evaluacion2Label: UILabel!
    @IBOutlet weak var evaluacion3Label: UILabel!
    @IBOutlet weak var evaluacionBoton11: UIButton!
    @IBOutlet weak var evaluacionBoton12: UIButton!
    @IBOutlet weak var evaluacionBoton13: UIButton!
    @IBOutlet weak var evaluacionBoton14: UIButton!
    @IBOutlet weak var evaluacionBoton15: UIButton!
    @IBOutlet weak var evaluacionBoton21: UIButton!
    @IBOutlet weak var evaluacionBoton22: UIButton!
    @IBOutlet weak var evaluacionBoton23: UIButton!
    @IBOutlet weak var evaluacionBoton24: UIButton!
    @IBOutlet weak var evaluacionBoton25: UIButton!
    @IBOutlet weak var evaluacionBoton31: UIButton!
    @IBOutlet weak var evaluacionBoton32: UIButton!
    @IBOutlet weak var evaluacionBoton33: UIButton!
    @IBOutlet weak var evaluacionBoton34: UIButton!
    @IBOutlet weak var evaluacionBoton35: UIButton!
    @IBOutlet weak var comentariosTextView: UITextView!
    var evaluacion1 = 0
    var evaluacion2 = 0
    var evaluacion3 = 0
    let finishedAlert = UIAlertController(title: "Encuesta enviada!", message: "Gracias por tu evaluacion!", preferredStyle: UIAlertControllerStyle.Alert)
    var restaurantNombreTicket = ""
    var dateTicket = ""
    var restaurantIdTicket = 0
    var restaurantId = 0
    var ticket = 0
    var token = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantTicketLabel.text = restaurantNombreTicket
        // Do any additional setup after loading the view.
        comentariosTextView.delegate = self
        dateTicketLabel.text = dateTicket
    }
    @IBAction func Buton11action(sender: AnyObject) {
        evaluacion1 = 1
        evaluacion1Label.text = "Malo"
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton12.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton12.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton13.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton13.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton14.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton14.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton15.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton15.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton12action(sender: AnyObject) {
        evaluacion1 = 2
        evaluacion1Label.text = "Regular"
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton12.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton12.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton13.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton13.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton14.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton14.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton15.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton15.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton13action(sender: AnyObject) {
        evaluacion1 = 3
        evaluacion1Label.text = "Bueno"
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton12.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton12.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton13.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton13.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton14.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton14.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton15.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton15.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton14action(sender: AnyObject) {
        evaluacion1 = 4
        evaluacion1Label.text = "Muy bueno"
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton12.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton12.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton13.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton13.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton14.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton14.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton15.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton15.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton15action(sender: AnyObject) {
        evaluacion1 = 5
        evaluacion1Label.text = "Excelente"
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton11.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton12.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton12.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton13.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton13.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton14.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton14.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton15.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton15.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
    }
    @IBAction func Buton21action(sender: AnyObject) {
        evaluacion2 = 1
        evaluacion2Label.text = "Malo"
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton22.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton22.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton23.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton23.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton24.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton24.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton25.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton25.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton22action(sender: AnyObject) {
        evaluacion2 = 2
        evaluacion2Label.text = "Regular"
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton22.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton22.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton23.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton23.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton24.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton24.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton25.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton25.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton23action(sender: AnyObject) {
        evaluacion2 = 3
        evaluacion2Label.text = "Bueno"
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton22.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton22.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton23.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton23.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton24.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton24.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton25.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton25.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton24action(sender: AnyObject) {
        evaluacion2 = 4
        evaluacion2Label.text = "Muy bueno"
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton22.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton22.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton23.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton23.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton24.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton24.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton25.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton25.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton25action(sender: AnyObject) {
        evaluacion2 = 5
        evaluacion2Label.text = "Excelente"
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton21.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton22.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton22.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton23.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton23.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton24.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton24.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton25.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton25.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
    }
    @IBAction func Buton31action(sender: AnyObject) {
        evaluacion3 = 1
        evaluacion3Label.text = "Malo"
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton32.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton32.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton33.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton33.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton34.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton34.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton35.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton35.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton32action(sender: AnyObject) {
        evaluacion3 = 2
        evaluacion3Label.text = "Regular"
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton32.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton32.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton33.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton33.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton34.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton34.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton35.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton35.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton33action(sender: AnyObject) {
        evaluacion3 = 3
        evaluacion3Label.text = "Bueno"
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton32.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton32.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton33.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton33.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton34.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton34.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
        evaluacionBoton35.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton35.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton34action(sender: AnyObject) {
        evaluacion3 = 4
        evaluacion3Label.text = "Muy bueno"
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton32.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton32.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton33.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton33.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton34.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton34.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton35.setImage(UIImage(named: "rate-.png"), forState: .Normal)
        evaluacionBoton35.setImage(UIImage(named: "rate-.png"), forState: .Highlighted)
    }
    @IBAction func Buton35action(sender: AnyObject) {
        evaluacion3 = 5
        evaluacion3Label.text = "Excelente"
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton31.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton32.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton32.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton33.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton33.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton34.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton34.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
        evaluacionBoton35.setImage(UIImage(named: "rate+.png"), forState: .Normal)
        evaluacionBoton35.setImage(UIImage(named: "rate+.png"), forState: .Highlighted)
    }
    
    @IBAction func finalizarEncuestaAction(sender: AnyObject) {
        if evaluacion1 == 0 || evaluacion2 == 0 || evaluacion3 == 0 {
            print("Alguno de las evaluaciones no esta completa")
            let optionAlert = UIAlertController(title: "Encuesta incompleta", message: "Para finalizar debes evaluar las 3 preguntas", preferredStyle: UIAlertControllerStyle.Alert)
            
            optionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in

            }))
            
            self.presentViewController(optionAlert, animated: true, completion: nil)
        } else {
            print("Encuesta completa")
            progressBarDisplayer("Enviando", true)
            let result = ConnectDB().sendPoll(token, idRestaurant: restaurantIdTicket, ticket: ticket, people: evaluacion1, process: evaluacion2, product: evaluacion3, comment: comentariosTextView.text!)
            sendResquest(result)
            self.performSegueWithIdentifier("finishedPollSegue", sender: self)
            //self.presentViewController(finishedAlert, animated: true, completion: nil)
            //NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("dismissAlert"), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func cancelPoll(sender: AnyObject) {
        progressBarDisplayer("Guardando", true)
        let result = ConnectDB().sendNoPoll(token, ticket: ticket, idRestaurant: restaurantIdTicket)
        sendResquest(result)
        self.performSegueWithIdentifier("finishedPollSegue", sender: self)
    }
    
    func sendResquest(result : NSURLRequest) {
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
    func textViewDidBeginEditing(textView: UITextView) {
        animateViewMoving(true, moveValue: 184)
    }
    func textViewDidEndEditing(textView: UITextView) {
        animateViewMoving(false, moveValue: 184)
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
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func dismissAlert()
    {
        // Dismiss the alert from here
        //self.finishedAlert.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("finishedPollSegue", sender: self)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
