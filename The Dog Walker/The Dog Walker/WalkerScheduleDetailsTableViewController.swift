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
            
            if let textField = alert.textFields{
                let fields = textField as [UITextField]
                let enteredText = fields[0].text
                print(enteredText!)
                
                if enteredText == ""{
                    
                    //dev
                    print("EMPTY")
                    
                    FieldValidation.textFieldAlert("Enter note", message: "Please enter note upon check out", presenter: self)
                }else{
                    //dev
                    print("SAVE")
                    
                    //set checkIn to true
                    self.ref.updateChildValues(["checkOut": true, "notes": enteredText!])
                }
            }
            
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
}



