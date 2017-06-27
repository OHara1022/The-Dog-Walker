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
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var petRef: DatabaseReference!
    var userRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var fullName: String?
    var phone: String?
    var address: String?
    var companyCode: String?
    
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
    }
    
    //MARK: -- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        //set observer to retreive pet data for edit text
        petRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
//                print(snapshot)
                
                //get obj values as dictionary
                let pet = PetModel(dictionary: dictionary)
                
                //dev
                print(pet.petName!)
                
                //set edit text w/ obj values
                self.petNameTF.text = pet.petName!
                self.instructionTF.text = pet.specialIns!
                self.medTF.text = pet.meds!
            }
            
        }, withCancel: nil)
        
         //set observer to retreive user data for edit text
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //                print(snapshot)
                
                //get user data as dictionary
                let user = UserModel(dictionary: dictionary)
                
                //dev
                print(user.firstName!)
                
                self.fullName = user.firstName! + " " + user.lastName!
                self.phone = user.phoneNumber!
                self.address = user.address! + ". " + user.city! + ", " + user.state! + " " + user.zipCode!
                self.companyCode = user.companyCode!
                
                //if apt number add to address label
                if user.aptNumber != nil{
                    //dev
                    print("APT HIT")
                    //address w/ apt number
                    self.address = user.address! + ".  Apt." + user.aptNumber! + " " + user.city! + ", " + user.state! + " " + user.zipCode!
                }
                
            }
            
        }, withCancel: nil)
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
            self.ref.child(scheduleKey).setValue(["date": newSchedule.date, "time": newSchedule.time, "duration": newSchedule.duration, "petName": newSchedule.petName, "specialIns": newSchedule.instructions, "meds": newSchedule.meds, "scheduleKey": scheduleKey, "uid": userID!, "clientName": fullName!, "clientPhone": phone!, "clientAddress": address!, "paidFlag": false, "companyCode": companyCode!])
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
