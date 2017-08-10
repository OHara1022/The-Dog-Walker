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


//add activity indicator to make sure data is loaded (research how to walk for save to DB from register)
class WelcomeViewController: UIViewController {

    //MARK: -- stored properties
    var ref: DatabaseReference!
    var roleID: String = "roleID"
//     var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(indicator)
//        indicator.activityIndicatorViewStyle = .whiteLarge
//        indicator.center = view.center
//        indicator.startAnimating()
        Auth.auth().addStateDidChangeListener{ auth, user in
        
            //check if user is signed in
            if let user = user {
                //dev
                print("logged in?" + " " +  user.uid)
                
                //get ref of current user
                self.ref = Database.database().reference().child(users).child(user.uid)
//                
//                if self.ref != nil{
//                    
//                    self.indicator.stopAnimating()
//                }
                
            }
        }//end of listener
        
    }
    
    //MARK: -- actions
    @IBAction func dogWalkerBTN(_ sender: UIButton) {
        
        //set role in DB to walker
        ref.child(roleID).setValue("Walker")
        
    }
    
    @IBAction func petOwnerBTN(_ sender: UIButton) {
        
        //set role in DB to Owner
        ref.child(roleID).setValue("Owner")
    }
    
}
