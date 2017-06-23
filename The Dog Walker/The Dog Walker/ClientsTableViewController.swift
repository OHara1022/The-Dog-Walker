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
    var clientRef: DatabaseReference!
    var clientData: NSDictionary!
    let userID = Auth.auth().currentUser?.uid
    var currentCode: String?
    var userRef: DatabaseReference!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasoure to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //init dictionary
        clientData = NSDictionary()
        
        //set DB ref
        clientRef = Database.database().reference().child("users")
        userRef = Database.database().reference().child("users")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //dev
            //            print(snapshot)
            
            let code = snapshot.value as! NSDictionary
            
            self.currentCode = code.value(forKey: "companyCode") as? String
            
            //dev
            //            print(self.current!)
            
        })
        
        self.clientRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //dev
            //            print(snapshot)
            
            self.clientData = snapshot.value as! NSDictionary
            
            self.tableView.reloadData()
            
        })
    }
    
    // MARK: -- table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clientData.count
    }
    
    var cell: UITableViewCell?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath)
        
        
        let obj = self.clientData.allValues[(indexPath as NSIndexPath).row] as! NSDictionary
        
        let name = obj.value(forKey: "firstName") as! String
        let roleID = obj.value(forKey: "roleID") as? String
        let walkerCode = obj.value(forKey: "companyCode") as? String
        
        print(name)
        if roleID == "Owner" && walkerCode == self.currentCode{
            // Configure the cell...
            cell?.textLabel?.text = name
            
            return cell!
        }
        
        cell?.isHidden = true
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "clientDetails", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 0.0
        
        if cell?.isHidden == true {
            
            height = 0.0
        }else {
            
            height = 44.0
        }
        
        return height
    }
    
    
    // MARK: -- navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
//        if segue.identifier == "clientDetails"{
//            
//            if let index = sender as? IndexPath{
//                
//                
//                let clientDetails = segue.destination as! ClientProfileTableViewController
//                
//                let obj = self.clientData.allValues[(index as NSIndexPath).row] as! NSDictionary
//                
//                clientDetails.firstNameHolder = obj.value(forKey: "firstName") as? String
//            }
//        
//        }
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
