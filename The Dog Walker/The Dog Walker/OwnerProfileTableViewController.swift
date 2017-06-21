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
    
    //MARK: -- outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emergencyContactLabel: UILabel!
    @IBOutlet weak var emergencyPhoneLabel: UILabel!
    
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    //refenerce to  home VC - instantiant walkerHome VC
    lazy var homeVC: UIViewController? = {
        //init homeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "home")
        //return vc
        return homeVC
    }()
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set DB reference 
        ref = Database.database().reference().child("users").child(userID!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //dev
            print(snapshot)
            
            //get values of current user
            let userValues = snapshot.value as? NSDictionary
            
            //get object value as string
            let firstName = userValues?.value(forKey: "firstName") as? String
            let lastName = userValues?.value(forKey: "lastName") as? String
            let email = userValues?.value(forKey: "email") as? String
            let phone = userValues?.value(forKey: "phoneNumber") as? String
            
            let addressValue = userValues?.value(forKey: "address") as? NSDictionary
            
            let address = addressValue?.value(forKey: "address") as? String
            let city = addressValue?["city"] as? String
            
            //dev
            print(address!)
            print(city!)
            
            self.nameLabel.text = firstName! + " " + lastName!
            self.emailLabel.text = email!
            self.phoneLabel.text = phone!
            self.addressLabel.text = address
            
        })
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
