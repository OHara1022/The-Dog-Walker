//
//  OwnerScheduleTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class OwnerScheduleTableViewController: UITableViewController {
    
    //TESTING POC
    var holderTest: [String] = ["Paid", "Paid","Paid","Paid","Paid"]
    var test: UILabel?
    //    test?.textColor = UIColor.green
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var dateInfo: NSDictionary!
    let userID = Auth.auth().currentUser?.uid//get current user id
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasoure to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //init dictionary
        dateInfo = NSDictionary()
        
        //set ref of database to scheudles
        ref = Database.database().reference().child("schedules").child(userID!)
        
    }
    
    //MARK: -- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        //add observer tp listen for changes in schedules
        self.ref.observe(.value, with: { (snapshot) in
            
            //check if tableView has values
            if (snapshot.hasChildren()){
                
                self.dateInfo = snapshot.value as! NSDictionary
            }
            //reload tableView
            self.tableView.reloadData()
        })
        
    }
    
    //MARK: -- viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        //remove observers
        ref.removeAllObservers()
    }
    
    //MARK: -- table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of data in array
        return dateInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "ownerScheduleCell", for: indexPath) as! OwnerScheudlesTableViewCell
        
        //get values of schedule from FB
        let dateObj = self.dateInfo.allValues[(indexPath as NSIndexPath).row] as! NSDictionary
        
        let scheduleDate = dateObj.value(forKey: "date") as? String
        
        cell.dateLabel.text = scheduleDate
        cell.paidLabel.text = holderTest[indexPath.row]
        test = cell.paidLabel
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dateInfo.count != 0 {
            
            self.performSegue(withIdentifier: "scheduleDetails", sender: indexPath)
            
        }
    }
    
    
    // MARK: -- navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "scheduleDetails" {
            
            if let index = sender as? IndexPath{
                
                let details = segue.destination as! OwnerScheudleDetailsTableViewController
                
                let obj = self.dateInfo.allValues[(index as NSIndexPath).row] as! NSDictionary
                
                //dev
                print(obj.value(forKey: "petName") as! String)
                print(obj.value(forKey: "date") as! String)
                print(obj.value(forKey: "time") as! String)
                print(obj.value(forKey: "duration") as! String)
                print(obj.value(forKey: "specialIns") as! String)
                print(obj.value(forKey: "meds") as! String)
                print(obj.value(forKey: "scheduleKey") as! String)
                
                //pass values to details VC
                details.petNameHolder = obj.value(forKey: "petName") as? String
                details.dateHolder = obj.value(forKey: "date") as? String
                details.timeHolder = obj.value(forKey: "time") as? String
                details.durationHolder = obj.value(forKey: "duration") as? String
                details.specialInsHolder = obj.value(forKey: "specialIns") as? String
                details.medHolder = obj.value(forKey: "meds") as? String
                details.scheduleKeyHolder = obj.value(forKey: "scheduleKey") as? String
                
            }
        }
        
    }
    
    
    //TODO: Delete schedule!!!
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
    
}
