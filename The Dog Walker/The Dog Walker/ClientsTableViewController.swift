//
//  ClientsTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase


//TODO: get snapshot of all users - ?query by child equal to companyCode if exists display clients/pets on index selection (reference ownerscheudleTVC)
class ClientsTableViewController: UITableViewController {
    
    //MARK: -- store properties
    let userID = Auth.auth().currentUser?.uid
    var userRef: DatabaseReference!
    var clientRef: DatabaseReference!
    var cell: UITableViewCell?
    var walkerCode: String?
    var clientsList = [UserModel]()
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasoure to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //set DB ref
        clientRef = Database.database().reference().child("users")
        userRef = Database.database().reference().child("users")
        
        //set observer to current user
        userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                let user = UserModel(dictionary: dictionary)
                
                //get walker code
                self.walkerCode = user.companyCode
                
                //dev
                //print("WALKER" + " " + self.walkerCode!)
            }
            
        }, withCancel: nil)
        
        //set client observer
        clientRef.observe(.childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //populate class w/ snapshot
                let user = UserModel(dictionary: dictionary)
                
                //append snapshot to array
                self.clientsList.append(user)
                
                //dispatch on main thread or app will crash!!
                DispatchQueue.main.async(execute: {
                    //reload tableView
                    self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
        
    }
    
    
    // MARK: -- table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clientsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath)
        
        //get obj a indexPath
        let clients = clientsList[indexPath.row]
        
        //set obj values
        let roleID = clients.roleID!
        let code = clients.companyCode!
        let name = clients.firstName! + " " + clients.lastName!
        
        //dev
        print(code)
        
        //check role and code to make relation to walker clients
        if roleID == "Owner" && walkerCode == code{
            // Configure the cell...
            cell?.textLabel?.text = name
            
            return cell!
        }
        
        //hide cells that are not related
        cell?.isHidden = true
        return cell!
    }
    
    //MARK: -- didSelectRow
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check array has value
        if clientsList.count != 0{
            //perform segue to detaisl
            performSegue(withIdentifier: "clientDetails", sender: indexPath)
        }
    }
    
    //MARK: -- heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //set default height
        var height: CGFloat = 0.0
        
        //check if cell is hidden
        if cell?.isHidden == true {
            
            //set height
            height = 0.0
        }else {
            //set height
            height = 44.0
        }
        
        //return proper height
        return height
    }

    // MARK: -- prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "clientDetails"{
            
            if let index = sender as? IndexPath{
                
                let detailDestination = segue.destination as! ProfilesViewController
                
                let clientDetails = clientsList[index.row]
                
                detailDestination.currentClient = clientDetails
                
            }
        }
    }
    
}

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
