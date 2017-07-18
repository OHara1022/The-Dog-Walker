//
//  OwnerEditScheduleViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class OwnerEditScheduleViewController: UIViewController {
    
    //MARK: --stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    //holder strings
    var date: String?
    var time: String?
    var duration: String?
    var price: String?
    var petName: String?
    var specialIns: String?
    var meds: String?
    var scheduleKey: String?

    //MARK: --outlets
    @IBOutlet weak var editDateTF: UITextField!
    @IBOutlet weak var editTimeTF: UITextField!
    @IBOutlet weak var editDurationTF: UITextField!
    @IBOutlet weak var editPriceLBL: UILabel!
    @IBOutlet weak var editPetNameTF: UITextField!
    @IBOutlet weak var editSpecialInsTF: UITextField!
    @IBOutlet weak var editMedsTF: UITextField!
    
    //MARK: --viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init ref to database
        ref = Database.database().reference().child("schedules").child(userID!).child(scheduleKey!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot values
                let schedule = ScheduleModel(dictionary: dictionary)
                
                //                print(schedule.date!)
                
                //set label w/ passed values
                //populate TF w/ passed data
                self.editDateTF.text = schedule.date
                 self.editTimeTF.text =  schedule.time
                 self.editDurationTF.text =  schedule.duration
                 self.editPriceLBL.text =  schedule.price
                self.editPetNameTF.text =  schedule.petName
                 self.editSpecialInsTF.text =  schedule.specialIns
                 self.editMedsTF.text =  schedule.meds
                
                if  self.editSpecialInsTF.text == ""{
                     self.editSpecialInsTF.text = "None"
                }
            }
            
        }, withCancel: nil)

    }
    
    
    //MARK: --actions
    @IBAction func saveEditChanges(_ sender: Any) {
        
        //get TF text
        let date = editDateTF.text
        let time = editTimeTF.text
        let duration = editDurationTF.text
        let price = editPriceLBL.text
        let petName = editPetNameTF.text
        let specialIns = editSpecialInsTF.text
        let meds = editMedsTF.text
        //populate schedule class
        let updatedSchedule = ScheduleData(date: date!, time: time!, duration: duration!, petName: petName!, instructions: specialIns!, meds: meds!, price: price!)
        
        //update schedule value in datebase
        ref.updateChildValues(["date": updatedSchedule.date, "time": updatedSchedule.time, "duration": updatedSchedule.duration, "price": updatedSchedule.price, "petName": updatedSchedule.petName, "specialIns": updatedSchedule.instructions, "meds": updatedSchedule.meds])
        
        //perform segue to details w/ updated values
        self.performSegue(withIdentifier: "updateView", sender: self)
    }
}
