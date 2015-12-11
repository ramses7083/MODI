//
//  ScanViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 08/05/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var QRLabel: UILabel!
    @IBOutlet weak var ScanView: UIView!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var qrData:String!
    var databasePath = NSString()
    var token : String!
    var RestaurantId : Int!
    var Mesa : Int!
    var imagen : UIImage!
    var messageFrame = UIView()
    var activityIndicatorM = UIActivityIndicatorView()
    var strLabel = UILabel()
    @IBOutlet weak var lightButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            //input = try AVCaptureDeviceInput.deviceInputWithDevice(captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()

        // Move the message label to the top view
        view.bringSubviewToFront(QRLabel)
        view.bringSubviewToFront(lightButton)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
       
    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            QRLabel.text = "Escanea el Codigo QR de la mesa"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            /*
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            */
            if metadataObj.stringValue != nil {
                //QRLabel.text = metadataObj.stringValue
                qrData=metadataObj.stringValue
                if qrData.characters.count > 22 {
                    let modiURL = qrData.substringWithRange(0, end: 22)
                    if (modiURL  == "http://www.modi.mx/qr/" ) {
                        progressBarDisplayer("Descargando", true)
                        captureSession?.stopRunning()
                        let datosRyM = qrData.substringWithRange(Range<String.Index>(start: qrData.startIndex.advancedBy(22), end: qrData.endIndex))
                        let datosRyMarray = datosRyM.componentsSeparatedByString("/")
                        RestaurantId = Int(datosRyMarray[0])
                        Mesa = Int(datosRyMarray[1])
                        let result = ConnectDB().getRestaurantDetails(token, id: "\(RestaurantId)")
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
                                        
                                        //Descargar imagen
                                        let urlString = "\(responseDictionary["cabecera"]!)"
                                        let imgURL = NSURL(string: urlString)
                                        let request: NSURLRequest = NSURLRequest(URL: imgURL!)
                                        let mainQueue = NSOperationQueue.mainQueue()
                                        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                                            if error == nil {
                                                // Convert the downloaded data in to a UIImage object
                                                self.imagen = UIImage(data: data!)
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    self.performSegueWithIdentifier("QRsegue", sender: self)
                                                })
                                            }
                                            else {
                                                print("Error: \(error!.localizedDescription)")
                                            }
                                        })
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
    }
    func checkRestaurantSesion(){
        //Revisar la sesión previa
        let connectDB = ConnectDB()
        databasePath = connectDB.consultDB()
        let datosSesion = connectDB.checkSession(databasePath as String)
        token = datosSesion[6] as! String
        RestaurantId = (datosSesion[7] as! NSString).integerValue
        Mesa = (datosSesion[8] as! NSString).integerValue
        if RestaurantId != 0 {
            progressBarDisplayer("Descargando", true)
            let result = ConnectDB().getRestaurantDetails(token, id: "\(RestaurantId)")
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
                            
                            //Descargar imagen
                            let urlString = "\(responseDictionary["cabecera"]!)"
                            let imgURL = NSURL(string: urlString)
                            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
                            let mainQueue = NSOperationQueue.mainQueue()
                            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                                if error == nil {
                                    // Convert the downloaded data in to a UIImage object
                                    self.imagen = UIImage(data: data!)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.performSegueWithIdentifier("QRsegue", sender: self)
                                    })
                                }
                                else {
                                    print("Error: \(error!.localizedDescription)")
                                }
                            })
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
            progressBarDisplayer("Descargando", false)
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
    @IBAction func lightButton(sender: AnyObject) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    device.torchMode = AVCaptureTorchMode.Off
                    self.lightButton.setTitle("Encender Luz", forState: .Normal)
                } else {
                    try device.setTorchModeOnWithLevel(1.0)
                    self.lightButton.setTitle("Apagar Luz", forState: .Normal)
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    self.lightButton.setTitle("Apagar Luz", forState: .Normal)
                } else {
                    self.lightButton.setTitle("Encender Luz", forState: .Normal)
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
        //Revisar la sesión previa
        checkRestaurantSesion()
        
        captureSession?.startRunning()
        super.viewWillAppear(animated)
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "QRsegue") {
            let vc : SelectedRestaurantViewController = segue.destinationViewController as! SelectedRestaurantViewController
            print("Restaurante:\(RestaurantId) y mesa:\(Mesa)")
            ConnectDB().updateRestaurant(databasePath, idRestaurant: RestaurantId, idMesa: Mesa)
            vc.RestautanteID = "\(RestaurantId)"
            vc.imagen = imagen
            vc.qrViewController = true
            let backItem = UIBarButtonItem(title: "ok", style: .Plain, target: vc.self, action: "ejectTable:")
            navigationItem.backBarButtonItem = backItem
            navigationItem.setHidesBackButton(true, animated: true)
        }
    }


}
extension String
{
    func substringWithRange(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(end))
        return self.substringWithRange(range)
    }
    
    func substringWithRange(start: Int, location: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if location < 0 || start + location > self.characters.count
        {
            print("end index \(start + location) out of bounds")
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(start + location))
        return self.substringWithRange(range)
    }
}
