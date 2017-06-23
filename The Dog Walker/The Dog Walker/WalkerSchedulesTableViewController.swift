//
//  WalkerSchedulesTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

//TODO: fix override when another owner schedule is added to DB
class WalkerSchedulesTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var scheduleData: NSDictionary!
    var userRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var role: String?
    var walkerCode: String?
    var current: String?
    var userInfo: [String] = []//for testing add in class to pull data (reference lets code video)
    
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
    
    //MARK: -- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        //set observer to users
        self.userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //            print(snapshot)
            
            //check snapshot has value
            if snapshot.hasChildren(){
                let code = snapshot.value as! NSDictionary
                
                self.current = code.value(forKey: "companyCode") as? String
                
                //            print(self.current!)
                
            }
        })
        
        //THIS TEST HITS BUT OVERLAPS TABLE VIEW
        self.userRef.observe(.value, with: { (snapshot) in
            
            print(snapshot)
            
            if snapshot.hasChildren(){
                
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
                            
                            self.ref.observe(.value, with: { (snapshot) in
                                
                                //print(snapshot)
                                if snapshot.hasChildren(){
                                for keys in (snapshot.value as! NSDictionary).allKeys{
                                    
                                    //print(keys)
                                    
                                    self.ref.child(keys as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                        
                                        //                        print(snapshot)
                                        
                                        self.scheduleData = snapshot.value as! NSDictionary
                                        
                                        self.tableView.reloadData()
                                    })
                                    
                                }
                                }
                                
                            })
                        })
                        
                    }
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
        userRef.removeAllObservers()
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
        let petName = obj.value(forKey: "petName") as! String
        
        print(date)
        
        //        if role == "Owner" && walkerCode == current{
        
        // Configure the cell...
        cell.textLabel?.text = date
        cell.detailTextLabel?.text = petName
        
        
        //        }
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "scheduleDetails", sender: indexPath)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let index = sender as? IndexPath{
            
            let details = segue.destination as! WalkerScheduleDetailsTableViewController
            
            let obj = self.scheduleData.allValues[(index as NSIndexPath).row] as! NSDictionary
            
            details.petNameHolder = obj.value(forKey: "petName") as? String
            details.dateHolder = obj.value(forKey: "date") as? String
            details.timeHolder = obj.value(forKey: "time") as? String
            details.durationHolder = obj.value(forKey: "duration") as? String
            details.specialInsHolder = obj.value(forKey: "specialIns") as? String
            details.medHolder = obj.value(forKey: "meds") as? String
            details.scheduleKeyHolder = obj.value(forKey: "scheduleKey") as? String
            details.clientNameHolder = obj.value(forKey: "clientName") as? String
            details.clientAddressHolder = obj.value(forKey: "clientAddress") as? String
            details.clientPhoneHolder = obj.value(forKey: "clientPhone") as? String
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


