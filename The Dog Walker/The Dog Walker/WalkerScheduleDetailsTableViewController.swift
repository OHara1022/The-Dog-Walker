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
    let phoneImage = UIImage(named: "phone")
    
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
    @IBOutlet weak var phoneBtnOutlet: UIButton!
  
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get ref to database
        ref = Database.database().reference().child("schedules").child(selectedSchedule.uid!).child(selectedSchedule.scheduleKey!)
    
        //dev
        print(selectedSchedule.scheduleKey!)
        
        //set button color to blue
        let tintImage = phoneImage?.withRenderingMode(.alwaysTemplate)
        phoneBtnOutlet.setImage(tintImage, for: .normal)
        phoneBtnOutlet.tintColor = UIColor(red:0.00, green:0.60, blue:0.80, alpha:1.0)
        
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
        
        //check if walk was paid
        if selectedSchedule.paidFlag == true{
            //set label to green
            paidLabel.textColor = UIColor.green
        }
        
        if let petImgURL = selectedSchedule.petImageUrl{
            //dev
            print(petImgURL)
            //set image to imageView
            self.petImage.loadImageUsingCache(petImgURL)
        }
    
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
    
    @IBAction func callContact(_ sender: UIButton) {
        
        //dev
        print("CALL")
        //present action sheet w/ call options
        presentCallOptions()
    }
    
    //MARK: -- call options action sheet
    func presentCallOptions(){
        
        //create action sheet
        let callActionSheet = UIAlertController(title: "Call Options", message: nil, preferredStyle: .actionSheet)
        
        //add actions
        callActionSheet.addAction(UIAlertAction(title: "Call Client", style: .default, handler: { action in
            
            //call client phone number
            self.callNumber(self.selectedSchedule.clientPhone!)
       
        }))
        
        callActionSheet.addAction(UIAlertAction(title: "Call Vet", style: .default, handler: { action in
            
            //call vet phone number
            self.callNumber(self.selectedSchedule.vetPhone!)
       
            
        }))
        
        callActionSheet.addAction(UIAlertAction(title: "Call Emergenct Contact", style: .destructive, handler: { action in
            
            //call emergency phone number
            self.callNumber(self.selectedSchedule.emergencyPhone!)
            
        }))
        
        //cancel btn
        callActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //present action sheet
        present(callActionSheet, animated: true, completion: nil)
    }
    
    
    //MARK: -- make phone call
    //open url for phone number
    func callNumber(_ phoneNumber:String) {
        //optional bind
        if let phoneCallURL:URL = URL(string:"tel://\(phoneNumber)") {
            //instance of shared app
            let application:UIApplication = UIApplication.shared
            //check if canOpenUrl
            if (application.canOpenURL(phoneCallURL)) {
                //openuRL
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}



