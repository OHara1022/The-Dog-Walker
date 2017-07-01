//
//  WalkerSchedulesTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase


class WalkerSchedulesTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
//    var roleID: String?
    var walkerCode: String?
//    var clientCode: String?
    var cell: UITableViewCell?
    var clientSchedules = [ScheduleModel]()
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasoure to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //set DB reference
        ref = Database.database().reference().child("schedules")
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
        
        //set observer to schedules
        ref.observe(.childAdded, with: { (snapshot) in
            
            //dev
            //print(snapshot)
            
            //get schedule key
            let uid = snapshot.key
            
            //get observer w/ key
            self.ref.child(uid).observe(.childAdded, with: { (snapshot) in
                
                //dev
                //print(snapshot)
                
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    
                    //populate data
                    let schedules = ScheduleModel(dictionary: dictionary)
                    
                    //append data to array
                    self.clientSchedules.append(schedules)
                    
                    //dispatch on main thread or app will crash!!
                    DispatchQueue.main.async(execute: {
                        //reload tableView
                        self.tableView.reloadData()
                    })
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    //remove observer when viewDisappears
    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }
    
    
    // MARK: -- table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return clientSchedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        let schedules = clientSchedules[indexPath.row]
        
        let code = schedules.companyCode!
        
        
        if walkerCode == code{
            
            // Configure the cell...
            cell?.textLabel?.text = schedules.date!
            cell?.detailTextLabel?.text = schedules.petName!
            
            return cell!
        }
        
        cell?.isHidden = true
        
        return cell!
        
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
    
    //MARK: -- didSelectRow
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //check schedules has value
        if clientSchedules.count != 0{
            
            //perform segue to details
            performSegue(withIdentifier: "scheduleDetails", sender: indexPath)
        }
    }
    
    // MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //get indexPath
        if let index = sender as? IndexPath{
            
            //get destination
            let details = segue.destination as! WalkerScheduleDetailsTableViewController
            
            //get row selected
            let scheduleDetails = self.clientSchedules[index.row]
            
            //pass object for row selected
            details.selectedSchedule = scheduleDetails
        }
    }
}
