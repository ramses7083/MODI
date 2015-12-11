//
//  PrincipalTabBarViewController.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 28/11/15.
//  Copyright © 2015 RASOFT. All rights reserved.
//

import UIKit

class PrincipalTabBarViewController: UITabBarController {
    var invitado = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if invitado {
            if let items = tabBar.items! as [UITabBarItem]! {
                items[1].enabled = false
                items[3].enabled = false
            }
        }
        
     
        // Do any additional setup after loading the view.
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
