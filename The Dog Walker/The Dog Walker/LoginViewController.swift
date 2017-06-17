//
//  LoginViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/5/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {
    
    @IBAction func loginTest(_ sender: UIButton) {
        
        //TESTING
        present(walkerhomeVC!, animated: true, completion: nil)
        
    }
    
    //refenerce to pet profile VC - instantiant petProfile VC
    lazy var walkerhomeVC: UIViewController? = {
        //init petVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "walkerHome")
        //return vc
        return homeVC
    }()
    
    //refenerce to pet profile VC - instantiant petProfile VC
    lazy var ownerhomeVC: UIViewController? = {
        //init petVC w/ identifier
        let ownerhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "ownerHome")
        //return vc
        return ownerhomeVC
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



}
