//
//  WalkerEditScheduleViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class WalkerEditScheduleViewController: UIViewController {
    
    //MARK: --stored properties
    var ref: DatabaseReference!
    var editSelectedSchedule: ScheduleModel!
    var scheduleKey: String?
    var scheduleUID: String?
    
    //MARK: --outlets
    @IBOutlet weak var editDateTF: UITextField!
    @IBOutlet weak var editTimeTF: UITextField!
    @IBOutlet weak var editDurationTF: UITextField!
    @IBOutlet weak var editPriceTF: UITextField!
    @IBOutlet weak var editPetNameTF: UITextField!
    @IBOutlet weak var editSpecialInsTF: UITextField!
    
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //dev
        print(scheduleKey!)
        
        //init ref to database
        ref = Database.database().reference().child(schedules).child(scheduleUID!).child(scheduleKey!)
        
        //set observer to get schedule values
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot values
                let schedule = ScheduleModel(dictionary: dictionary)
                
                        print(schedule.date!)
                
                //set label w/ passed values
                //populate TF w/ passed data
                self.editDateTF.text = schedule.date
                self.editTimeTF.text =  schedule.time
                self.editDurationTF.text =  schedule.duration
                self.editPriceTF.text =  schedule.price
                self.editPetNameTF.text =  schedule.petName
                self.editSpecialInsTF.text =  schedule.specialIns

                if  self.editSpecialInsTF.text == ""{
                    self.editSpecialInsTF.text = "None"
                }
            }
            
        }, withCancel: nil)
        
    }
    
    //MARK: --actions
    @IBAction func saveChangesBTN(_ sender: Any) {
        //dev
        print("save edit")
        self.performSegue(withIdentifier: "updateSchedule", sender: self)

    }
    






}
