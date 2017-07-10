//
//  WalkerEditScheduleViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class WalkerEditScheduleViewController: UIViewController {
    
    //MARK: --stored properties
    
    //MARK: --outlets
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: --actions
    @IBAction func saveChangesBTN(_ sender: Any) {
        //dev
        print("save edit")
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelEditBTN(_ sender: Any) {
        //dev
        print("cancel edit")
        dismiss(animated: true, completion: nil)

    }





}
