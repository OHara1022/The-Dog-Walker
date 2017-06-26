//
//  OwnerProfileTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class OwnerProfileTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var petRef: DatabaseReference!
    
    //refenerce to  home VC - instantiant walkerHome VC
    lazy var homeVC: UIViewController? = {
        //init homeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "home")
        //return vc
        return homeVC
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emergencyContactLabel: UILabel!
    @IBOutlet weak var emergencyPhoneLabel: UILabel!
    
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set DB reference
        ref = Database.database().reference().child("users").child(userID!)
        petRef = Database.database().reference().child("pets").child(userID!)
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //observer for pet info
        petRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
//                print(snapshot)
                
                //populate petModel w/ dictionary data
                let pet = PetModel(dictionary: dictionary)
                
                //dev
                print(pet.petName!)
                
                //populate label w/ data from FB
                self.emergencyContactLabel.text = pet.emergencyContact!
                self.emergencyPhoneLabel.text = pet.emergencyPhone!
            }
            
        }, withCancel: nil)
        
        //set observer for users
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //set snaopshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //get user data as dictionary
                let user = UserModel(dictionary: dictionary)

                //dev
                print(user.firstName!)
                
                //populate label w/ data from FB
                self.nameLabel.text = user.firstName! + " " + user.lastName!
                self.emailLabel.text = user.email!
                self.phoneLabel.text = user.phoneNumber!
                self.addressLabel.text = user.address! + ". " + user.city! + ", " + user.state! + " " + user.zipCode!
                
                //if apt number add to address label
                if user.aptNumber != nil{
                    //dev
                    print("APT HIT")
                    //address w/ apt number
                    self.addressLabel.text = user.address! + ".  Apt. " + user.aptNumber! + " " + user.city! + ", " + user.state! + " " + user.zipCode!
                }
             
            }
            
        }, withCancel: nil)
        
    }
    
    //MARK: -- actions
    @IBAction func signOutBtn(_ sender: Any) {
        
        //sign user out w/ firebase auth
        try! Auth.auth().signOut()
        
        //present walkerHomeVC
        homeVC?.modalTransitionStyle = .flipHorizontal
        present(homeVC!, animated: true, completion: nil)
    }
    
    
}

