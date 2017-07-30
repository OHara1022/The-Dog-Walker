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
    var petRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    //refenerce to  home VC - instantiant walkerHome VC
    lazy var homeVC: UIViewController? = {
        //init homeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "home")
        //return vc
        return homeVC
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityStateZipLbael: UILabel!
    @IBOutlet weak var emergencyContactLabel: UILabel!
    @IBOutlet weak var emergencyPhoneLabel: UILabel!
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set DB reference
        ref = Database.database().reference().child(users).child(userID!)
        petRef = Database.database().reference().child(pets).child(userID!)
    }
    
    //MARK: --viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        //set observer for users
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //set snaopshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //get user data as dictionary
                let user = UserModel(dictionary: dictionary)
                
                //get profile image
                if let profileImgURL = user.profileImage{
                    //dev
                    print(profileImgURL)
                    
                    //set profile image w/ URL
                    self.profileImage.loadImageUsingCache(profileImgURL)
                }
                
                //dev
//                print(user.firstName!)
                
                //populate label w/ data from FB
                self.nameLabel.text = user.firstName! + " " + user.lastName!
                self.emailLabel.text = user.email!
                self.phoneLabel.text = user.phoneNumber!
                
                //if apt number add to address label
                if user.aptNumber == ""{
                    //dev
                    print("APT HIT")
                    //address w/ apt number
                    self.addressLabel.text = user.address! + "demo 1. "
                    
                    self.cityStateZipLbael.text = user.city! + ", " + user.state! + " " + user.zipCode!
                }else{
                    self.addressLabel.text = user.address! + ". Apt. " + user.aptNumber!
                    
                    self.cityStateZipLbael.text = user.city! + ", " + user.state! + " " + user.zipCode!
                }
                
            }
            
        }, withCancel: nil)
        
        //observer for pet info
        petRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
//                print(snapshot)
            
                //populate petModel w/ dictionary data
                let pet = PetModel(dictionary: dictionary)
                
                //dev
//                print(pet.petName!)
                
                //populate label w/ data from FB
                self.emergencyContactLabel.text = pet.emergencyContact!
                self.emergencyPhoneLabel.text = pet.emergencyPhone!
            }
            
        }, withCancel: nil)
 
    }
    
    //MARK: -- actions
    @IBAction func updateProfileView(segue: UIStoryboardSegue){
        
        //set observer for users
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //set snaopshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //get user data as dictionary
                let user = UserModel(dictionary: dictionary)
                
                //dev
//                print(user.firstName!)
                
                //set profile img w/ URL
                if let profileImgURL = user.profileImage{
                    //dev
                    print(profileImgURL)
                    
                    self.profileImage.loadImageUsingCache(profileImgURL)
                }
            
                //populate label w/ data from FB
                self.nameLabel.text = user.firstName! + " " + user.lastName!
                self.emailLabel.text = user.email!
                self.phoneLabel.text = user.phoneNumber!
                
                //if apt number add to address label
                if user.aptNumber == ""{
                    //dev
                    print("APT HIT")
                    //address w/ apt number
                    self.addressLabel.text = user.address! + ". " + user.city! + ", " + user.state! + " " + user.zipCode!
                }else{
                    self.addressLabel.text = user.address! + ". Apt. " + user.aptNumber! + " " + user.city! + ", " + user.state! + " " + user.zipCode!
                }

            }
            
        }, withCancel: nil)
        
        //observer pet info
        petRef.observeSingleEvent(of: .childChanged, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //populate petModel w/ dictionary
                let pet = PetModel(dictionary: dictionary)
                
                //dev
                print(pet.emergencyContact!)
                //populate label w/ data returned from edit 
                self.emergencyContactLabel.text = pet.emergencyContact!
                self.emergencyPhoneLabel.text = pet.emergencyPhone!
            
            }
        }, withCancel: nil)
    }
    
    @IBAction func signOutBtn(_ sender: Any) {
        
        //sign user out w/ firebase auth
        try! Auth.auth().signOut()
        
        //present walkerHomeVC
        homeVC?.modalTransitionStyle = .flipHorizontal
        present(homeVC!, animated: true, completion: nil)
    }
    
    
}

