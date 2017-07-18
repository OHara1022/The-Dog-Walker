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
    var scheduleKey: String?
    var activeField: UITextField?
    
    //pickerViews
    var timePicker: UIDatePicker!
    var datePicker: UIDatePicker!
    var durationPicker: UIPickerView!
    
    //MARK: --outlets
    @IBOutlet weak var editDateTF: UITextField!
    @IBOutlet weak var editTimeTF: UITextField!
    @IBOutlet weak var editDurationTF: UITextField!
    @IBOutlet weak var editPriceLBL: UILabel!
    @IBOutlet weak var editPetNameTF: UITextField!
    @IBOutlet weak var editSpecialInsTF: UITextField!
    @IBOutlet weak var editMedsTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: --viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init ref to database
        ref = Database.database().reference().child(schedules).child(userID!).child(scheduleKey!)
        
        //set observer to get schedule values
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
        
        //set TF delegate
        setTFDelegate()
        
        //init time picker & set mode, inputView, & target
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        editTimeTF.inputView = timePicker
        timePicker.addTarget(self, action: #selector(self.timePickerValueChanged), for: UIControlEvents.valueChanged)
        //set item bar time values
        pickerItem(title: "Time", textField: editTimeTF, selector: #selector(OwnerEditScheduleViewController.donePickerPressed))
        
        //init date picker & set mode, inputView, & target
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        editDateTF.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        //set item bar date values
        pickerItem(title: "Date", textField: editDateTF, selector:  #selector(OwnerEditScheduleViewController.donePickerPressed))
        
        //init duration pickerView, set delegate & datasource
        durationPicker  = UIPickerView()
        durationPicker.tag = 0
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.delegate = self
        editDurationTF.inputView = durationPicker
        //set item bar duration value
        pickerItem(title: "Duration", textField: editDurationTF, selector: #selector(CreateScheduleViewController.donePickerPressed))
        
        //broadcast info and add observer for when keyboard shows and hides
        NotificationCenter.default.addObserver(self, selector: #selector(OwnerEditScheduleViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OwnerEditScheduleViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    
    //set size of scroll view to the view content size
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 800)
    }
}
