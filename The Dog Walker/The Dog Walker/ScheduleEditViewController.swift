//
//  ScheduleEditViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 7/26/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class ScheduleEditViewController: UIViewController {
    
    //MARK: --stored properties
    var ref: DatabaseReference!
     var petRef: DatabaseReference!
    var scheduleKey: String?
    var activeField: UITextField?
    let userID = Auth.auth().currentUser?.uid
    
    //pickerViews
    var timePicker: UIDatePicker!
    var datePicker: UIDatePicker!
    var durationPicker: UIPickerView!
    
    //MARK: --outlets
    @IBOutlet weak var editDateTF: UITextField!
    @IBOutlet weak var editTimeTF: UITextField!
    @IBOutlet weak var petNameLBL: UILabel!
    @IBOutlet weak var editPriceLBL: UILabel!
    @IBOutlet weak var editDurationTF: UITextField!
    @IBOutlet weak var editSpecialInsTF: UITextField!
    @IBOutlet weak var editMedsTF: UITextField!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    
    //MARK: --viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init ref to database
        ref = Database.database().reference().child(schedules).child(userID!).child(scheduleKey!)
        
         petRef = Database.database().reference().child(pets).child(userID!)
        
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
                self.petNameLBL.text =  schedule.petName
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
        pickerItem(title: "Time", textField: editTimeTF, selector: #selector(ScheduleEditViewController.donePickerPressed))
        
        //init date picker & set mode, inputView, & target
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        editDateTF.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        //set item bar date values
        pickerItem(title: "Date", textField: editDateTF, selector:  #selector(ScheduleEditViewController.donePickerPressed))
        
        //init duration pickerView, set delegate & datasource
        durationPicker  = UIPickerView()
        durationPicker.tag = 0
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.delegate = self
        editDurationTF.inputView = durationPicker
        //set item bar duration value
        pickerItem(title: "Duration", textField: editDurationTF, selector: #selector(ScheduleEditViewController.donePickerPressed))
        
        //broadcast info and add observer for when keyboard shows and hides
        NotificationCenter.default.addObserver(self, selector: #selector(ScheduleEditViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScheduleEditViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        petRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //populate petModel w/ dictionary
                let pet = PetModel(dictionary: dictionary)
                
                if let petImgURL = pet.petImage{
                    //dev
                    print(petImgURL)
                    //set image to imageView
                    self.petImage.loadImageUsingCache(petImgURL)
                }
                
            }
        }, withCancel: nil)
    }
    
    
    //MARK: --actions
    @IBAction func saveEditChanges(_ sender: Any) {
        
        //check for empty TF
        if (!FieldValidation.isEmpty(editDateTF, presenter: self) && !FieldValidation.isEmpty(editTimeTF, presenter: self) &&
            !FieldValidation.isEmpty(editDurationTF, presenter: self)  && !FieldValidation.isEmpty(editMedsTF, presenter: self)){
            
            //get TF text
            let date = editDateTF.text
            let time = editTimeTF.text
            let duration = editDurationTF.text
            let price = editPriceLBL.text
            let petName = petNameLBL.text
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
    
    //set size of scroll view to the view content size
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 700)
    }

 

}
