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
        
        //set DB reference
        ref = Database.database().reference().child("users").child(userID!)
        
        
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
                self.nameLBL.text = user.firstName! + " " + user.lastName!
                self.emailLBL.text = user.email!
                self.phoneLBL.text = user.phoneNumber!
                self.addressLBL.text = user.address! + ". " + user.city! + ", " + user.state! + " " + user.zipCode!
                
                //if apt number add to address label
                if user.aptNumber != nil{
                    //dev
                    print("APT HIT")
                    //address w/ apt number
                    self.addressLBL.text = user.address! + ".  Apt. " + user.aptNumber! + " " + user.city! + ", " + user.state! + " " + user.zipCode!
                }
                
                if user.companyName != nil{
                    
                    self.companyNameLBL.text = user.companyName!
                }
                
            }
            
        }, withCancel: nil)
        
        
        //
        //        ref.observeSingleEvent(of: .value, with: {(snapshot) in
        //            //dev
        //            print(snapshot)
        //
        //            //get values of current user
        //            let userValues = snapshot.value as? NSDictionary
        //
        //            //get object value as string
        //            //get object value as string
        //            let firstName = userValues?.value(forKey: "firstName") as? String
        //            let lastName = userValues?.value(forKey: "lastName") as? String
        //            let email = userValues?.value(forKey: "email") as? String
        //            let phone = userValues?.value(forKey: "phoneNumber") as? String
        //             let companyName = userValues?.value(forKey: "companyName") as? String
        //
        //            //get address object
        //            let addressValue = userValues?.value(forKey: "address") as? NSDictionary
        //            //get values from address object
        //            let address = addressValue?.value(forKey: "address") as? String
        //            let city = addressValue?["city"] as? String
        //            let state = addressValue?["state"] as? String
        //            let zipCode = addressValue?["zipCode"] as? String
        //
        //            if companyName != nil{
        //
        //                self.companyNameLBL.text = companyName!
        //            }
        //
        //            self.nameLBL.text = firstName! + " " + lastName!
        //            self.emailLBL.text = email!
        //            self.phoneLBL.text = phone!
        //            self.addressLBL.text = address! + " " + city! + ", " + state! + " " + zipCode!
        //
        //        })
    }
    
    //MARK: -- actions
    @IBAction func signOut(_ sender: Any) {
        
        //sign user out w/ firebase auth
        try! Auth.auth().signOut()
        
        //present walkerHomeVC
        homeVC?.modalTransitionStyle = .flipHorizontal
        present(homeVC!, animated: true, completion: nil)
    }
    
    
}


// MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
