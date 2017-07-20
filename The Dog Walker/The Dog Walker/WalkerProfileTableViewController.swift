//
//  WalkerProfileTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

//TODO: hide company cell if no data is available
class WalkerProfileTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid//get current user userID
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    //refenerce to walker home VC - instantiant walkerHome VC
    lazy var homeVC: UIViewController? = {
        //init walkerHomeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeID")
        //return vc
        return homeVC
    }()
  
    //MARK: -- outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var emailLBL: UILabel!
    @IBOutlet weak var phoneLBL: UILabel!
    @IBOutlet weak var addressLBL: UILabel!
    @IBOutlet weak var companyNameCell: UIView!
    @IBOutlet weak var companyNameTitle: UILabel!
    @IBOutlet weak var companyNameLBL: UILabel!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(indicator)
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = profileImage.center
        indicator.startAnimating()
        
        //set DB reference
        ref = Database.database().reference().child("users").child(userID!)
        //observe ref to users
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //set snaopshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //get user data as dictionary
                let user = UserModel(dictionary: dictionary)
                
                //dev
                print(user.firstName!)
                
                if let profileImgURL = user.profileImage{
                    
                    self.profileImage.loadImageUsingCache(profileImgURL)
                    
                    self.indicator.stopAnimating()
                }
                
                //populate label w/ data from FB
                self.nameLBL.text = user.firstName! + " " + user.lastName!
                self.emailLBL.text = user.email!
                self.phoneLBL.text = user.phoneNumber!
                
                //if apt number add to address label
                if user.aptNumber == ""{
                    //dev
                    print("APT HIT")
                    //address w/ apt number
                    self.addressLBL.text = user.address! + ". " + user.city! + ", " + user.state! + " " + user.zipCode!
                }else{
                    self.addressLBL.text = user.address! + ".  Apt. " + user.aptNumber! + " " + user.city! + ", " + user.state! + " " + user.zipCode!
                }
                
                if user.companyName != nil{
                    
                    self.companyNameLBL.text = user.companyName!
                }
                
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
                print(user.firstName!)
                
                if let profileImgURL = user.profileImage{
                    
                    print(profileImgURL)
                    
                    self.profileImage.loadImageUsingCache(profileImgURL)
                }
                
                
                //populate label w/ data from FB
                self.nameLBL.text = user.firstName! + " " + user.lastName!
                self.emailLBL.text = user.email!
                self.phoneLBL.text = user.phoneNumber!
                
                //if apt number add to address label
                if user.aptNumber == ""{
                    //dev
                    print("APT HIT")
                    //address w/ apt number
                    self.addressLBL.text = user.address! + ". " + user.city! + ", " + user.state! + " " + user.zipCode!
                }else{
                    self.addressLBL.text = user.address! + ".  Apt. " + user.aptNumber! + " " + user.city! + ", " + user.state! + " " + user.zipCode!
                }
                
                if user.companyName != nil{
                    
                    self.companyNameLBL.text = user.companyName!
                }
                
             
            }
            
        }, withCancel: nil)
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        
        //sign user out w/ firebase auth
        try! Auth.auth().signOut()
        
        //present walkerHomeVC
        homeVC?.modalTransitionStyle = .flipHorizontal
        present(homeVC!, animated: true, completion: nil)
    }
    
    
}
