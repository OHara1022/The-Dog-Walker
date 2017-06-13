//
//  RegisterViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/12/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    //TODO: Optimize onboarding to register for Alpha
    @IBOutlet weak var walkerOrOwner: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        walkerOrOwner.isHidden = true
    }

   
}
