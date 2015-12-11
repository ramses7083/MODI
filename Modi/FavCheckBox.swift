//
//  CheckBox.swift
//  checkbox
//
//  Created by kent on 9/27/14.
//  Copyright (c) 2014 kent. All rights reserved.
//

import UIKit

class FavCheckBox: UIButton {
    var restaurantID = ""
    var token = ""
    //images
    let checkedImage = UIImage(named: "checked_checkbox")
    let unCheckedImage = UIImage(named: "unchecked_checkbox")
    
    //bool propety
    var isChecked:Bool = false{
        didSet{
            if isChecked == true{
                self.setImage(checkedImage, forState: .Normal)
            }else{
                self.setImage(unCheckedImage, forState: .Normal)
            }
        }
    }

    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    


    func buttonClicked(sender:UIButton) {
        if(sender == self){
            if isChecked == true{
                isChecked = false
                print("CheckBox NO marcado")
                let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/unfav-restaurant/\(restaurantID)/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
                request.HTTPMethod = "POST"
                request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                    if error != nil {
                        // handle error here
                        print("Error al principio")
                        print(error)
                        return
                    }
                    
                    // if response was JSON, then parse it
                    /*let respuestaServidor = JSON(data: data!, options: [], error: nil)
                    print("resp:\(respuestaServidor)")
                    dispatch_async(dispatch_get_main_queue()) {
                    //     // update your UI and model objects here
                    
                    }
                    */
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
            }else{
                isChecked = true
                print("CheckBox marcado")
                let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/fav-restaurant/\(restaurantID)/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
                request.HTTPMethod = "POST"
                request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                    if error != nil {
                        // handle error here
                        print("Error al principio")
                        print(error)
                        return
                    }
                    
                    // if response was JSON, then parse it
                    /*let respuestaServidor = JSON(data: data!, options: [], error: nil)
                    print("resp:\(respuestaServidor)")
                    dispatch_async(dispatch_get_main_queue()) {
                        //     // update your UI and model objects here
                
                    }
                    */
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
    }

}
