//
//  LoginViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/5/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailLoginTF: UITextField!
    @IBOutlet weak var passwordLoginTF: UITextField!
    
    
    //MARK: -- stored properties
    //refenerce to walker home VC - instantiant walkerHome VC
    lazy var walkerhomeVC: UIViewController? = {
        //init walkerHomeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "walkerHome")
        //return vc
        return homeVC
    }()
    
    //refenerce to ownerhomeVC - instantiant ownerhomeVC
    lazy var ownerhomeVC: UIViewController? = {
        //init ownerhomeVC w/ identifier
        let ownerhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "ownerHome")
        //return vc
        return ownerhomeVC
    }()
    
    
    //MARK: -- actions
    @IBAction func loginTest(_ sender: UIButton) {
        
        if emailLoginTF.text == "walker"{
        
        //present walkerHomeVC
        present(walkerhomeVC!, animated: true, completion: nil)
            
        }else if emailLoginTF.text == "owner"{
            
            //present walkerHomeVC
            present(ownerhomeVC!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Enter Email", message: "Enter walker or owner in email field", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Forgot Password?", message: "Will send recover email in furture release", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
  
    
    //TODO: get snapshot of users, check role (walker/owner) - transition to proper homeVC
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



}
