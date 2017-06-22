//
//  WalkerSchedulesTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

//TODO: get snapshot of all users - ?query by child equal to companyCode if exists display clients/pets on index selection (reference ownerscheudleTVC)
class WalkerSchedulesTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var scheduleData: NSDictionary!
    var userRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var userInfo: [String] = []
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasoure to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //init dictionary
        scheduleData = NSDictionary()
        
        //set DB reference
        ref = Database.database().reference().child("schedules")
        userRef = Database.database().reference().child("users")
        
    }
    
    var role: String?
    var walkerCode: String?
    var current: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        
        self.userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //            print(snapshot)
            
            let code = snapshot.value as! NSDictionary
            
            self.current = code.value(forKey: "companyCode") as? String
            
            //            print(self.current!)
            
        })
        
        self.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            for keys in (snapshot.value as! NSDictionary).allValues{
                
                let roleKey = keys as! NSDictionary
                
                let roleID = roleKey.value(forKey: "roleID") as? String
                
                let walkerCode = roleKey.value(forKey: "companyCode") as? String
                
                print(roleID!)
                print(walkerCode!)
                
                self.role = roleID!
                self.walkerCode = walkerCode!
                
                if roleID == "Owner"  && self.walkerCode == self.current{
                    
                    print("HIT")
                    
                    self.ref.observe(.value, with: { (snapshot) in
                        
                        //print(snapshot)
                        
                        for keys in (snapshot.value as! NSDictionary).allKeys{
                            
                            //print(keys)
                            
                            self.ref.child(keys as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                //print(snapshot)
                                self.scheduleData = snapshot.value as! NSDictionary
                                
                                self.tableView.reloadData()
                            })
                            
                        }
                    })
                }
            }
        })
    }
    
    // MARK: -- table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return scheduleData.count
    }
    
    var testCode: String?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        let obj = self.scheduleData.allValues[(indexPath as NSIndexPath).row] as! NSDictionary
        //dev
        //        print(obj)
        
        let date = obj.value(forKey: "date") as! String
        
        print(date)
        userInfo.append(date)
        
        // Configure the cell...
        cell.textLabel?.text = date
        cell.detailTextLabel?.text = "Scott"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "scheduleDetails", sender: indexPath)
    }
    
    
    // MARK: - Navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    //        if let index = sender as? IndexPath{
    //
    //            let details = segue.destination as! WalkerScheduleDetailsTableViewController
    //
    //        }
    //
    //    }
    
    
    
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
}


