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
    var fullName: String?
    var phone: String?
    var fullAddress: String?
    var companyCode: String?
    var petImageUrl: String?
    var vetName: String?
    var vetPhone: String?
    var emergencyContact: String?
    var emergencyPhone: String?
    var breed: String?
    var activeField: UITextField?
    let userID = Auth.auth().currentUser?.uid

    //pickerViews
    var timePicker: UIDatePicker!
    var datePicker: UIDatePicker!
    var durationPicker: UIPickerView!

    //MARK: -- outlets
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var durationTF: UITextField!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var petNameLBL: UILabel!
    @IBOutlet weak var instructionTF: UITextField!
    @IBOutlet weak var medTF: UITextField!
    @IBOutlet weak var specialInsLBL: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: --- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get ref to database
        ref = Database.database().reference().child(schedules).child(userID!)
        petRef = Database.database().reference().child(pets).child(userID!)
        userRef = Database.database().reference().child(users).child(userID!)
        
        //set TF delegate
        setTFDelegate()
        
        //init date picker & set mode, inputView, & target
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dateTF.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        //set item bar date values
        pickerItem(title: "Date", textField: dateTF, selector:  #selector(CreateScheduleViewController.donePickerPressed))
        
        //init time picker & set mode, inputView, & target
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timeTF.inputView = timePicker
        timePicker.addTarget(self, action: #selector(self.timePickerValueChanged), for: UIControlEvents.valueChanged)
        //set item bar time values
        pickerItem(title: "Time", textField: timeTF, selector: #selector(CreateScheduleViewController.donePickerPressed))
    
        //init duration pickerView, set delegate & datasource
        durationPicker  = UIPickerView()
        durationPicker.tag = 0
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.delegate = self
        durationTF.inputView = durationPicker
        //set item bar duration value
        pickerItem(title: "Duration", textField: durationTF, selector: #selector(CreateScheduleViewController.donePickerPressed))
        
        //broadcast info and add observer for when keyboard shows and hides
        NotificationCenter.default.addObserver(self, selector: #selector(CreateScheduleViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateScheduleViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
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
                self.petNameLBL.text = pet.petName!
                self.instructionTF.text = pet.specialIns!
                self.medTF.text = pet.meds!
                self.petImageUrl = pet.petImage!
                self.vetName = pet.vetName!
                self.vetPhone = pet.vetPhone!
                self.emergencyContact = pet.emergencyContact!
                self.emergencyPhone = pet.emergencyPhone!
                self.breed = pet.breed!
                
                if self.instructionTF.text == ""{
                    //dev
                    print("INS EMPTY")
                    
                    //set text to none
                    self.instructionTF.text = "None"
                }
            }
        }, withCancel: nil)
        
         //set observer to retreive user data for edit text
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //get user data as dictionary
                let user = UserModel(dictionary: dictionary)
                
                //dev
                print(user.firstName!)
                
                self.fullName = user.firstName! + " " + user.lastName!
                self.phone = user.phoneNumber!
                self.companyCode = user.companyCode!
                
                if user.aptNumber == ""{
                    //dev
                    print("APT HIT")
                    //address w/o apt number
                    self.fullAddress = user.address! + ". " + user.city! + ", " + user.state! + " " + user.zipCode!
                }else{
                    self.fullAddress = user.address! + ". Apt. " + user.aptNumber! + " " + user.city! + ", " + user.state! + " " + user.zipCode!
                }
               
            }
            
        }, withCancel: nil)
    }
    
    //set size of scroll view to the view content size
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 700)
    }

    //MARK: -- actions
    @IBAction func saveSchedule(_ sender: Any) {
        
        //check for empty TF
        if (!FieldValidation.isEmpty(dateTF, presenter: self) && !FieldValidation.isEmpty(timeTF, presenter: self) &&
            !FieldValidation.isEmpty(durationTF, presenter: self) && !FieldValidation.isEmpty(medTF, presenter: self)){
            
            //retreive textField text
            let date = dateTF.text
            let time = timeTF.text
            let duration = durationTF.text
            let petName = petNameLBL.text
            let specialIns = instructionTF.text
            let meds = medTF.text
            let price = priceLbl.text
            
            //generate key for each schedule
            let scheduleKey = ref.childByAutoId().key
            
            //populate class with text field values
            let newSchedule = ScheduleData(date: date!, time: time!, duration: duration!, petName: petName!, instructions: specialIns!, meds: meds!, price: price!)
            
            //set values to push to firebase
            self.ref.child(scheduleKey).setValue(["date": newSchedule.date, "time": newSchedule.time, "duration": newSchedule.duration, "petName": newSchedule.petName, "specialIns": newSchedule.instructions, "meds": newSchedule.meds, "price": newSchedule.price, "scheduleKey": scheduleKey, "uid": userID!, "clientName": fullName!, "clientPhone": phone!, "clientAddress": fullAddress!, "paidFlag": false, "checkIn": false, "checkOut": false, "companyCode": companyCode!, "vetName": vetName!, "vetPhone": vetPhone!, "petImage": petImageUrl!, "emergencyContact": emergencyContact!, "emergencyPhone": emergencyPhone!, "breed": breed!])
            
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
