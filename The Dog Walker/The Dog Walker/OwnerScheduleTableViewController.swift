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
class OwnerScheduleTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var paidRef: DatabaseReference!
    var schedulesArray = [ScheduleModel]()
    var cell: UITableViewCell?
    let userID = Auth.auth().currentUser?.uid
    
    //TODO: show unpaid on checkout
    var paid: String = "Paid"
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasoure to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //set ref of database to scheudles
        ref = Database.database().reference().child(schedules).child(userID!)
//        paidRef = Database.database().reference().child(schedules).child(userID!)
        
        //observer for schedules added
        ref.observe(.childAdded, with: { (snapshot) in
            
            //get snapshot
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot to scheudleModel
                let schedules = ScheduleModel(dictionary: dictionary)
                
                //append schedule data
                self.schedulesArray.append(schedules)
                //dev
                //                print(schedules.paidFlag!)
                
                //check if walk was completed and paid for
                if  schedules.checkOut == true && schedules.paidFlag != true{
                    
                    //dev
                    print("WALK COMPLETE")
                    
                    //alert user walk was completed
                    let alert = UIAlertController(title: "Walker Complete", message: "Notes: " + schedules.notes! + " " + "Please pay for walk on" + " " + schedules.date!, preferredStyle: .alert)
                    //add alert action
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    }))
                    //present alert
                    self.present(alert, animated: true)
                }
                
                if schedules.checkIn == true && schedules.paidFlag != true && schedules.checkOut == false{
                    
                    FieldValidation.textFieldAlert(schedules.petName! + " " + "walk has started", message: "Your walk scheduled on" + " " + schedules.date! + " " + "has begun",  presenter: self)
                }
                
            
                //dispatch on main thread or app will crash!!
                DispatchQueue.main.async(execute: {
                    //reload tableView
                    self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
        
        //observer for schedules added
        ref.observe(.childChanged, with: { (snapshot) in
            
            //get snapshot
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot to scheudleModel
                let schedules = ScheduleModel(dictionary: dictionary)
                
                //append schedule data
                self.schedulesArray.append(schedules)
                
                //check if walk was completed and paid for
                if  schedules.checkOut == true && schedules.paidFlag != true{
                    
                    //dev
                    print("WALK COMPLETE")
                    
                    //alert user walk was completed
                    let alert = UIAlertController(title: "Walker Complete", message: "Notes: " + schedules.notes! + " " + "Please pay for walk on" + " " + schedules.date!, preferredStyle: .alert)
                    //add alert action
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    }))
                    //present alert
                    self.present(alert, animated: true)
                }
                
                if schedules.checkIn == true && schedules.paidFlag != true && schedules.checkOut == false{
                    
                    FieldValidation.textFieldAlert(schedules.petName! + " " + "walk has started", message: "Your walk scheduled on" + " " + schedules.date! + " " + "has begun",  presenter: self)
                }
                
                //dispatch on main thread or app will crash!!
                DispatchQueue.main.async(execute: {
                    //reload tableView
                    self.tableView.reloadData()
                })
            }
        })
        
    }
    
    //TESTING
    override func viewWillAppear(_ animated: Bool) {
        
//
//        paidRef.observeSingleEvent(of: .childChanged, with: { (snapshot) in
//            
//            //get snapshot
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                
//                //get snapshot to scheudleModel
//                let schedules = ScheduleModel(dictionary: dictionary)
//                
//                print(schedules.date!)
//                
//                //check if payment was made
//             
//                    //TODO: fix paid label to show on walk completion
//                    self.cell?.detailTextLabel?.text = self.paid
//                    //set paid label to green
//                    self.cell?.detailTextLabel?.textColor = UIColor(red:0.18, green:0.66, blue:0.15, alpha:1.0)
//             
//                
//                //dispatch on main thread or app will crash!!
//                DispatchQueue.main.async(execute: {
//                    //reload tableView
//                    self.tableView.reloadData()
//                })
//                
//            }
//        }, withCancel: nil)
    }
    
    //MARK: -- table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of data in array
        return schedulesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        cell = tableView.dequeueReusableCell(withIdentifier: "ownerScheduleCell", for: indexPath)
        
        //get values of schedule from FB
        let schedule = schedulesArray[indexPath.row]
        
        //populate labels with schdule data
        cell?.textLabel?.text = schedule.date!
        
        //check if payment was made
        if schedule.paidFlag == true{
            //TODO: fix paid label to show on walk completion
            self.cell?.detailTextLabel?.text = paid
            //set paid label to green
            self.cell?.detailTextLabel?.textColor = UIColor(red:0.18, green:0.66, blue:0.15, alpha:1.0)
            
        }else{
            //TODO: fix paid label to show on walk completion
            self.cell?.detailTextLabel?.text = ""
  
        }
        

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //check that data is available
        if schedulesArray.count != 0 {
            
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
                let scheduleDetail = self.schedulesArray[index.row]
                
                details.selectedSchedule = scheduleDetail
            }
        }
    }
    
    //MARK: -- edit cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //MARK: -- edit style
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //get selected indexPath
            let schedules = self.schedulesArray[indexPath.row]
            
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
                    self.schedulesArray.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
            }
        }
    }
}
