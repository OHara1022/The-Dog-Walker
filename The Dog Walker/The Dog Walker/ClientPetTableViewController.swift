//
//  ClientPetTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

//TODO: get snapshot of all users - ?query by child equal to companyCode if exists display client info (reference ownerscheudleTVC)
class ClientPetTableViewController: UITableViewController {

    //MARK: -- stored properties
    var petRef: DatabaseReference!
    var petInfo: NSDictionary!
    let userID = Auth.auth().currentUser?.uid//get current user id
    var userRef: DatabaseReference!
    
    //MARK: -- outles
    @IBOutlet weak var clientPetImg: UIImageView!
    @IBOutlet weak var petNameLBL: UILabel!
    @IBOutlet weak var bdayLBL: UILabel!
    @IBOutlet weak var breedLBL: UILabel!
    @IBOutlet weak var vaccineLBL: UILabel!
    @IBOutlet weak var medsLBL: UILabel!
    @IBOutlet weak var specialInsLBL: UILabel!
    @IBOutlet weak var vetNameLBL: UILabel!
    @IBOutlet weak var vetPhoneLBL: UILabel!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //init dictionary
        petInfo = NSDictionary()
        
        //set ref to db
        petRef = Database.database().reference().child("pets")
    
    }

    override func viewWillAppear(_ animated: Bool) {
        
        petRef.ref.observe(.value, with: { (snapshot) in
            
            print(snapshot)
        })
    }
   
   

}


// MARK: - Table view data source

// override func numberOfSections(in tableView: UITableView) -> Int {
// #warning Incomplete implementation, return the number of sections
//    return 0
//  }

// override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
// #warning Incomplete implementation, return the number of rows
//    return 0
// }

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
