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


//TODO: check if email is in DB
class WelcomeViewController: UIViewController {

    //MARK: -- stored properties
    var ref: DatabaseReference!
    var roleID: String = "roleID"
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener{ auth, user in
            
            //check if user is signed in
            if let user = user {
                //dev
                print("logged in?" + " " +  user.uid)
                
                self.ref = Database.database().reference().child("users").child(user.uid)
            }
        }//end of listener
        
    }
    
    //MARK: -- actions
    @IBAction func dogWalkerBTN(_ sender: UIButton) {
        
        ref.child(roleID).setValue("Walker")
        
    }
    
    @IBAction func petOwnerBTN(_ sender: UIButton) {
        
        ref.child(roleID).setValue("Owner")
    }
    
}
