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
    var walkerCode: String?
    var cell: UITableViewCell?
    var clientSchedules = [ScheduleModel]()
    let userID = Auth.auth().currentUser?.uid
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegate and datasoure to self
        tableView.delegate = self
        tableView.dataSource = self
        
        //set DB reference
        ref = Database.database().reference().child(schedules)
        userRef = Database.database().reference().child(users)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        
//        //set observer to schedules
//        ref.observe(.childAdded, with: { (snapshot) in
//            
//            //dev
//            //print(snapshot)
//            
//            //get schedule key
//            let uid = snapshot.key
//            
//            //get observer w/ key
//            self.ref.child(uid).observe(.childChanged, with: { (snapshot) in
//                
//                //dev
//                //print(snapshot)
//                
//                if let dictionary = snapshot.value as? [String:AnyObject]{
//                    
//                    //populate data
//                    let schedules = ScheduleModel(dictionary: dictionary)
//                    
//                    print(schedules.petName!)
//                    
//                    //append data to array
////                    self.clientSchedules.append(schedules)
//                    self.cell?.detailTextLabel?.text = schedules.petName!
//                    
//                    //dispatch on main thread or app will crash!!
//                    DispatchQueue.main.async(execute: {
//                        //reload tableView
//                        self.tableView.reloadData()
//                    })
//                }
//                
//            }, withCancel: nil)
//            
//        }, withCancel: nil)

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
        
        //get cell w/ identifier
        cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        //get schedule data
        let schedules = clientSchedules[indexPath.row]
        
        //get company code
        let code = schedules.companyCode!
        
        //check company code
        if walkerCode == code{
            
            //set cell label text
            cell?.textLabel?.text = schedules.date!
            cell?.detailTextLabel?.text = schedules.petName!
            
            return cell!
        }

        //hide cell that dont match company code
        cell?.isHidden = true
        //return tableView cell
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
