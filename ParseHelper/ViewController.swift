//
//  ViewController.swift
//  ParseHelper
//
//  Created by Vasu Laroiya on 7/23/15.
//  Copyright (c) 2015 Vasu Laroiya. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let parseLogic = ParseLogic.sharedInstance
        parseLogic.createUser("example@example.com", password: "password", confirmPassword: "password", parameters: ["fullName": "Example Example"]) { (success, errorMesssage) -> Void in
            if errorMesssage == nil {
                // User Created Successfully
            } else {
                // Error Occured
                println(errorMesssage)
            }
        }
        
        parseLogic.logInUser("example@example.com", password: "password") { (success, errorMesssage) -> Void in
            if success == false {
                // User Logged in Successfully
            } else {
                // Error Occured
                println(errorMesssage)
            }
        }
        
        parseLogic.sendForgotPasswordEmail("example@example.com", completion: { (success, errorMesssage) -> Void in
            if success == false {
                // User Logged in Successfully
            } else {
                // Error Occured
                println(errorMesssage)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

