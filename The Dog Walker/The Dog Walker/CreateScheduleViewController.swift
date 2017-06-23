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
    var petRef: DatabaseReference!
    var userRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var fullName: String?
    var phone: String?
    var address: String?
    
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
        
        //get ref to database
        ref = Database.database().reference().child("schedules").child(userID!)
        petRef = Database.database().reference().child("pets").child(userID!)
        userRef = Database.database().reference().child("users").child(userID!)
        
        //set observer to retrieve pet key
        petRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //dev
            print(snapshot)
            
            //check if shapshot has values
            if snapshot.hasChildren(){
                //loop thru snapshot to retrieve petKey
                for keys in((snapshot.value as! NSDictionary).allKeys){
                    //dev
                    print(keys)
                    //set key value
                    let key = keys
                    
                    //set observer to retrieve pet info values from FB DB
                    self.petRef.child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        print(snapshot)
                        //get snaphot as dictionary
                        let value = snapshot.value as? NSDictionary
                        
                        //set values
                        let petName = value?.value(forKey: "petName")
                        let instructions = value?.value(forKey: "specialIns")
                        let meds = value?.value(forKey: "meds")
                        
                        //dev
                        print(petName!)
                        //populate label with values from FB
                        self.petNameTF.text = petName as? String
                        self.instructionTF.text = instructions as? String
                        self.medTF.text = meds as? String
                        
                    })
                    
                }
            }
        })
    }
    
    
    //MARK: -- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        //get user info
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //dev
            print(snapshot)
            
            //check snapshot has value
            if snapshot.hasChildren(){
                
                //get values of current user
                let userValues = snapshot.value as? NSDictionary
                
                //get object value as string
                let firstName = userValues?.value(forKey: "firstName") as? String
                let lastName = userValues?.value(forKey: "lastName") as? String
                let phone = userValues?.value(forKey: "phoneNumber") as? String
                
                //get address object
                let addressValue = userValues?.value(forKey: "address") as? NSDictionary
                //get values from address object
                let address = addressValue?.value(forKey: "address") as? String
                let city = addressValue?["city"] as? String
                let state = addressValue?["state"] as? String
                let zipCode = addressValue?["zipCode"] as? String
                
                //dev
                print(address!)
                print(city!)
                print(firstName!)
                
                self.fullName = firstName! + " " + lastName!
                self.phone = phone
                self.address = address! + " " + city! + ", " + state! + " " + zipCode!
            }
        })
        
    }
    
    
    //MARK: -- actions
    @IBAction func saveSchedule(_ sender: Any) {
        
        if (!FieldValidation.isEmpty(dateTF, presenter: self) && !FieldValidation.isEmpty(timeTF, presenter: self) &&
            !FieldValidation.isEmpty(durationTF, presenter: self)){
            
            //retreive textField text
            let date = dateTF.text
            let time = timeTF.text
            let duration = durationTF.text
            let petName = petNameTF.text
            let specialIns = instructionTF.text
            let meds = medTF.text
            
            //generate key for each schedule
            let scheduleKey = ref.childByAutoId().key
            //populate class with text field values
            let newSchedule = ScheduleData(date: date!, time: time!, duration: duration!, petName: petName!, instructions: specialIns!, meds: meds!)
            
            //set values to push to firebase
            self.ref.child(scheduleKey).setValue(["date": newSchedule.date, "time": newSchedule.time, "duration": newSchedule.duration, "petName": newSchedule.petName, "specialIns": newSchedule.instructions, "meds": newSchedule.meds, "scheduleKey": scheduleKey, "uid": userID, "clientName": fullName, "clientPhone": phone, "clientAddress": address])
            //dev
            print("save schedule")
            //dismiss VC
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelSchedule(_ sender: Any) {
        //dev
        print("cancel schedule")
        dismiss(animated: true, completion: nil)
    }
    
}
