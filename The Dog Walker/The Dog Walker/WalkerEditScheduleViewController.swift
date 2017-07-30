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
    var petRef: DatabaseReference!
    var editSelectedSchedule: ScheduleModel!
    var scheduleKey: String?
    var scheduleUID: String?
    var activeField: UITextField?
    var meds: String?
    var specialIns: String?
    var price: String?
    
    //pickerViews
    var timePicker: UIDatePicker!
    var datePicker: UIDatePicker!
    var durationPicker: UIPickerView!
    
    //MARK: --outlets
    @IBOutlet weak var editDateTF: UITextField!
    @IBOutlet weak var editTimeTF: UITextField!
    @IBOutlet weak var editDurationTF: UITextField!
    @IBOutlet weak var editPriceLbl: UILabel!
    @IBOutlet weak var editPriceTF: UITextField!
    @IBOutlet weak var petNameLBL: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //dev
        print(scheduleKey!)
        
        editPriceTF.isHidden = true
        editPriceLbl.isHidden = true
        
        //init ref to database
        ref = Database.database().reference().child(schedules).child(scheduleUID!).child(scheduleKey!)
        
         petRef = Database.database().reference().child(pets).child(scheduleUID!)
        
        //init time picker & set mode, inputView, & target
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        editTimeTF.inputView = timePicker
        timePicker.addTarget(self, action: #selector(self.timePickerValueChanged), for: UIControlEvents.valueChanged)
        //set item bar time values
        pickerItem(title: "Time", textField: editTimeTF, selector: #selector(WalkerEditScheduleViewController.donePickerPressed))
        
        //init date picker & set mode, inputView, & target
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        editDateTF.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        //set item bar date values
        pickerItem(title: "Date", textField: editDateTF, selector:  #selector(WalkerEditScheduleViewController.donePickerPressed))
        
        //init duration pickerView, set delegate & datasource
        durationPicker  = UIPickerView()
        durationPicker.tag = 0
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.delegate = self
        editDurationTF.inputView = durationPicker
        //set item bar duration value
        pickerItem(title: "Duration", textField: editDurationTF, selector: #selector(WalkerEditScheduleViewController.donePickerPressed))
        
        setTFDelegate()
        
        //broadcast info and add observer for when keyboard shows and hides
        NotificationCenter.default.addObserver(self, selector: #selector(WalkerEditScheduleViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WalkerEditScheduleViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: --viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
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
                self.editPriceTF.text =  schedule.price
                self.petNameLBL.text =  schedule.petName
                self.meds = schedule.meds
                self.specialIns =  schedule.specialIns
                self.price = schedule.price
            }
            
        }, withCancel: nil)
        
        //observer pet info
        petRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //populate petModel w/ dictionary
                let pet = PetModel(dictionary: dictionary)
                
                //dev
                //print(pet.petName!)
                
                if let petImgURL = pet.petImage{
                    //dev
                    print(petImgURL)
                    //set image to imageView
                    self.petImage.loadImageUsingCache(petImgURL)
                }
                
            }
        }, withCancel: nil)
    }
    
    //set size of scroll view to the view content size
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 650)
    }
    
    //MARK: --actions
    @IBAction func saveChangesBTN(_ sender: Any) {
        //dev
        print("save edit")
        
        //get TF text
        let date = editDateTF.text
        let time = editTimeTF.text
        let duration = editDurationTF.text
        let petName = petNameLBL.text
        let specialIns = self.specialIns
        let price = self.price
        let meds = self.meds
        //check for empty TF
        if (!FieldValidation.isEmpty(editDateTF, presenter: self) && !FieldValidation.isEmpty(editTimeTF, presenter: self) &&
            !FieldValidation.isEmpty(editDurationTF, presenter: self)){
            
        //populate schedule class
        let updatedSchedule = ScheduleData(date: date!, time: time!, duration: duration!, petName: petName!, instructions: specialIns!, meds: meds!, price: price!)
        
        //update schedule value in datebase
        ref.updateChildValues(["date": updatedSchedule.date, "time": updatedSchedule.time, "duration": updatedSchedule.duration, "price": updatedSchedule.price, "petName": updatedSchedule.petName, "specialIns": updatedSchedule.instructions, "meds": updatedSchedule.meds])
        
        self.performSegue(withIdentifier: "updateSchedule", sender: self)
        }
    }
}
