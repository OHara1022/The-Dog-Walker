//
//  CreateScheduleViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class CreateScheduleViewController: UIViewController {
    
    //TODO: Check fields empty 
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var petRef: DatabaseReference!

    //MARK: -- outlets
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var durationTF: UITextField!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var petNameTF: UITextField!
    @IBOutlet weak var instructionTF: UITextField!
    @IBOutlet weak var medTF: UITextField!
    
    //MARK: --- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("schedules").child(userID!)
        
        petRef = Database.database().reference().child("pets").child(userID!)
        
        petRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            for keys in((snapshot.value as! NSDictionary).allKeys){
                
                print(keys)
                let key = keys
                
                self.petRef.child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    
                    let value = snapshot.value as? NSDictionary
                    
                    let petName = value?.value(forKey: "petName")
                    let instructions = value?.value(forKey: "specialIns")
                    let meds = value?.value(forKey: "meds")
                    
                    //dev
                    print(petName!)
                    
                    self.petNameTF.text = petName as? String
                    self.instructionTF.text = instructions as? String
                    self.medTF.text = meds as? String
                
                })
            }

        })
     
    }

    
    //MARK: -- actions
    @IBAction func saveSchedule(_ sender: Any) {
        
        //retreive textField text
        let date = dateTF.text
        let time = timeTF.text
        let duration = durationTF.text
        let petName = petNameTF.text
        let specialIns = instructionTF.text
        let meds = medTF.text
        
        //generate key for each schedule
        let scheduleKey = ref.childByAutoId().key
        
        let newSchedule = ScheduleData(date: date!, time: time!, duration: duration!, petName: petName!, instructions: specialIns!, meds: meds!)
        
        self.ref.child(scheduleKey).setValue(["date": newSchedule.date, "time": newSchedule.time, "duration": newSchedule.duration, "petName": newSchedule.petName, "specialIns": newSchedule.instructions, "meds": newSchedule.meds, "scheduleKey": scheduleKey, "uid": userID])
        //dev
        print("save schedule")
        //dismiss VC
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelSchedule(_ sender: Any) {
        //dev
        print("cancel schedule")
        dismiss(animated: true, completion: nil)
    }
    
}
