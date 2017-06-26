//
//  OwnerScheduleTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

//TODO: change cell detail label to un-paid / paid on flag value from payment
//TODO: -- delete table view row (delete schdeudle), check empty fields, create flag for payment (local & remote)
class OwnerScheduleTableViewController: UITableViewController {
    
    //TESTING POC
    var holderTest: [String] = ["Unpaid", "Unpaid","Unpaid","Unpaid","Unpaid","Unpaid", "Unpaid","Unpaid","Unpaid","Unpaid","Unpaid", "Unpaid","Unpaid","Unpaid","Unpaid","Unpaid", "Unpaid","Unpaid","Unpaid","Unpaid", "Unpaid","Unpaid","Unpaid","Unpaid","Unpaid", "Unpaid","Unpaid","Unpaid","Unpaid"]
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    //    var dateInfo: NSDictionary!
    let userID = Auth.auth().currentUser?.uid//get current user id
    var schedules = [ScheduleModel]()
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasoure to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //init dictionary
        //        dateInfo = NSDictionary()
        
        //set ref of database to scheudles
        ref = Database.database().reference().child("schedules").child(userID!)
        
        //observer for schedules added
        ref.observe(.childAdded, with: { (snapshot) in
            
            //get snapshot
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot to scheudleModel
                let schedules = ScheduleModel(dictionary: dictionary)
                
                //append schedule data
                self.schedules.append(schedules)
                
                //dispatch on main thread or app will crash!!
                DispatchQueue.main.async(execute: {
                    //reload tableView
                    self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
    }
    
    
    //MARK: -- table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of data in array
        return schedules.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "ownerScheduleCell", for: indexPath) as! OwnerScheudlesTableViewCell
        
        //get values of schedule from FB
        let schedule = schedules[indexPath.row]
        
        //populate labels with schdule data
        cell.dateLabel.text = schedule.date!
        cell.paidLabel.text = holderTest[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //check that data is available
        if schedules.count != 0 {
            
            //perform segue to details
            self.performSegue(withIdentifier: "scheduleDetails", sender: indexPath)
        }
    }
    
    
    // MARK: -- navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //check idenitifer
        if  segue.identifier == "scheduleDetails" {
            
            //get indexPath as sender
            if let index = sender as? IndexPath{
                
                //set destination to details
                let details = segue.destination as! OwnerScheudleDetailsTableViewController
                
                //get row selected to pass proper data to details
                let scheduleDetail = self.schedules[index.row]
                
                details.selectedSchedule = scheduleDetail
                
                //pass values to details VC
                //                details.petNameHolder = scheduleDetail.petName!
                //                details.dateHolder = scheduleDetail.date!
                //                details.timeHolder = scheduleDetail.time!
                //                details.durationHolder = scheduleDetail.duration!
                //                details.specialInsHolder = scheduleDetail.specialIns!
                //                details.medHolder = scheduleDetail.meds!
                //                details.scheduleKeyHolder = scheduleDetail.scheduleKey!
                //                details.paidFlag = scheduleDetail.paidFlag!
            }
        }
        
    }
    
    
    //TODO: Delete schedule!!!
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //get selected indexPath
            let schedules = self.schedules[indexPath.row]
            
            //get scheduleKey
            if let scheduleKey = schedules.scheduleKey{
                
                //ref to remove
                ref.child(scheduleKey).removeValue(completionBlock: { (error, ref) in
                    
                    //check for error
                    if error != nil{
                        //dev
                        print(error!.localizedDescription)
                        return
                    }
                    //remove from array & table view
                    self.schedules.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                })
            }
        }
    }
    
    
}
