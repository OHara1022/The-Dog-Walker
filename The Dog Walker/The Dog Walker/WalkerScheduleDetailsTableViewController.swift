//
//  WalkerScheduleDetailsTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class WalkerScheduleDetailsTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var selectedSchedule: ScheduleModel!
    var ref: DatabaseReference!
    
    
    var priceHolder: String?  = "" //use on later release
    
    //MARK: --outlets
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var specialInsLabel: UILabel!
    @IBOutlet weak var medsLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var clientAddress: UILabel!
    @IBOutlet weak var clientPhone: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //populate labels w/ schedule data
        petNameLabel.text = selectedSchedule.petName
        dateLabel.text = selectedSchedule.date
        timeLabel.text = selectedSchedule.time
        durationLabel.text = selectedSchedule.duration
        specialInsLabel.text = selectedSchedule.specialIns
        medsLabel.text = selectedSchedule.meds
        clientLabel.text = selectedSchedule.clientName
        clientAddress.text = selectedSchedule.clientAddress
        clientPhone.text = selectedSchedule.clientPhone
        
        print(selectedSchedule.scheduleKey!)
        
        //get ref to database
        ref = Database.database().reference().child("schedules").child(selectedSchedule.uid!).child(selectedSchedule.scheduleKey!)
    }
    
    //MARK: -- actions
    @IBAction func checkIn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Check In", message: "Inform client walk has started?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            //set checkIn to true
            self.ref.updateChildValues(["checkIn": true])
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true)
        
    }
    
    @IBAction func checkOut(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Check Out", message: "Walk Completed?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "Enter Note"
        }
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            if let textFields = alert.textFields{
                let theTextFields = textFields as [UITextField]
                let enteredText = theTextFields[0].text
                print(enteredText!)
            }
            
            //set checkIn to true
            self.ref.updateChildValues(["checkOut": true])
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
}


// MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
