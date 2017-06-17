//
//  WelcomeViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/14/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class WelcomeViewController: UIViewController {
    
    //TODO: ALERT w/ textField to enter code to relate walker & client
    
    //get current user, add role to db, login walker, owner register pet then login
    
    //walker - sign in w/ FB auth????
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var roleHolder: String?
    let userID = Auth.auth().currentUser?.uid

    
    //MARK: -- actions
    @IBAction func dogWalkerBTN(_ sender: UIButton) {
        
//        ref.child("roleID").setValue(["roleID": "Walker"])
        
    }
    
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        ref = Database.database().reference().child("Users").child(userID!)
    }


}
