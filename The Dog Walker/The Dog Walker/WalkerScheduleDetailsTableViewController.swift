//
//  WalkerScheduleDetailsTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class WalkerScheduleDetailsTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var selectedSchedule: ScheduleModel!
    var ref: DatabaseReference!
    let phoneImage = UIImage(named: "phone")
    let directionsImg = UIImage(named: "directions")
    
    //MARK: --outlets
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var specialInsLabel: UILabel!
    @IBOutlet weak var medsLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var phoneBtnOutlet: UIButton!
    @IBOutlet weak var directionBtnOutlet: UIButton!
    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get ref to database
        ref = Database.database().reference().child(schedules).child(selectedSchedule.uid!).child(selectedSchedule.scheduleKey!)
        
        //dev
        print(selectedSchedule.scheduleKey!)
        
        //set button color to blue
        let tintPhone = phoneImage?.withRenderingMode(.alwaysTemplate)
        phoneBtnOutlet.setImage(tintPhone, for: .normal)
        phoneBtnOutlet.tintColor = UIColor(red:0.00, green:0.60, blue:0.80, alpha:1.0)
        
        let tintdir = directionsImg?.withRenderingMode(.alwaysTemplate)
        directionBtnOutlet.setImage(tintdir, for: .normal)
        directionBtnOutlet.tintColor = UIColor(red:0.00, green:0.60, blue:0.80, alpha:1.0)
        
        //check for pet image url
        if let petImgURL = selectedSchedule.petImageUrl{
            //dev
            print(petImgURL)
            //set image to imageView
            self.petImage.loadImageUsingCache(petImgURL)
        }
        
        //check if walk was paid
        if selectedSchedule.paidFlag == true{
            //set label to green
            paidLabel.textColor = UIColor.green
        }
    }
    
    //MARL: -- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        //observe schedule values
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot values
                let schedule = ScheduleModel(dictionary: dictionary)
                
                //                print(schedule.date!)
                
                //set label w/ passed values
                self.petNameLabel.text = schedule.petName
                self.dateLabel.text = schedule.date
                self.timeLabel.text = schedule.time
                self.durationLabel.text = schedule.duration
                self.specialInsLabel.text = schedule.specialIns
                self.medsLabel.text = schedule.meds
                
                if self.specialInsLabel.text == ""{
                    self.specialInsLabel.text = "None"
                }
                //get checkIn value
                if let checkIn = schedule.checkIn{
                    
                    //check checkIn state
                    if checkIn == true{
                        //disable checkIn btn
                        self.checkInBtn.isEnabled = false
                        self.checkInBtn.setTitleColor(.gray, for: .disabled)
                        
                    }else{
                        
                        //disable checkOut btn
                        self.checkOutBtn.isEnabled = false
                        self.checkOutBtn.setTitleColor(.gray, for: .disabled)
                    }
                }
                //check checkOut state
                if let checkOut = schedule.checkOut{
                    
                    if checkOut  == true{
                        //disable checkOut btn
                        self.checkOutBtn.isEnabled = false
                        self.checkOutBtn.setTitleColor(.gray, for: .disabled)
                    }
                }
            }
        }, withCancel: nil)
    }
    
    //MARK: --prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit"{
            
            let editSchedule = segue.destination as! WalkerEditScheduleViewController
            
            editSchedule.scheduleKey = selectedSchedule.scheduleKey
            editSchedule.scheduleUID = selectedSchedule.uid
            editSchedule.meds = selectedSchedule.meds
        }
    }
    
    
    //MARK: -- actions
    @IBAction func checkIn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Check In", message: "Inform client walk has started?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            //set checkIn to true
            self.ref.updateChildValues(["checkIn": true])
            
            self.checkOutBtn.isEnabled = true
            self.checkOutBtn.setTitleColor(UIColor(red:0.00, green:0.60, blue:0.80, alpha:1.0), for: .normal)
            
            self.checkInBtn.isEnabled = false
            self.checkInBtn.setTitleColor(.gray, for: .disabled)
            
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
                    
                    //disable checkOut btn
                    self.checkOutBtn.isEnabled = false
                    self.checkOutBtn.setTitleColor(.gray, for: .disabled)
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
    
    @IBAction func getDirections(_ sender: UIButton) {
        
        //dev
        print("GET DIRECTIONS")
        
        //get address
        CLGeocoder().geocodeAddressString(selectedSchedule.clientAddress!) { (places, error) in
            
            //check for error
            if error != nil{
                print("Geocode failed" + (error?.localizedDescription)!)
                
                //check for address
            }else if places!.count > 0{
                
                //get address from string
                let places = places![0]
                //get location from address
                let location = places.location
                //get coordinates from location
                let coords = location!.coordinate
                
                //dev
                print(coords.latitude)
                print(coords.longitude)
                
                //set coored in location manager
                let coordinates = CLLocationCoordinate2DMake(coords.latitude, coords.longitude)
                
                //get home address to place on map
                let home = MKPlacemark(coordinate: coordinates)
                
                //set map location
                let mapItem = MKMapItem(placemark: home)
                //set client address to route
                mapItem.name = self.selectedSchedule.clientAddress!
                
                //doesn't display phone when launch options for driving implemented
                //                mapItem.phoneNumber = self.selectedSchedule.clientPhone!
                
                //set options to driving and show traffic
                let mapOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey: true] as [String : Any]
                
                //open address w/ options in maps
                mapItem.openInMaps(launchOptions: mapOptions)
                
            }
        }
    }
    
    //MARK: --updateView
    @IBAction func updateSchedule(segue: UIStoryboardSegue){
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //get snapshot values
                let schedule = ScheduleModel(dictionary: dictionary)
                
                print(schedule.petName!)
                //populate labels w/ schedule data
                self.petNameLabel.text = schedule.petName
                self.dateLabel.text = schedule.date
                self.timeLabel.text = schedule.time
                self.durationLabel.text = schedule.duration
                self.specialInsLabel.text = schedule.specialIns
                
                //check if there are special ins
                if self.specialInsLabel.text == ""{
                    //set special ins to none
                    self.specialInsLabel.text = "None"
                }
            }
        })
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
        
        callActionSheet.addAction(UIAlertAction(title: "Call Emergency Contact", style: .destructive, handler: { action in
            
            //call emergency phone number
            self.callNumber(self.selectedSchedule.emergencyPhone!)
            
        }))
        
        //cancel btn
        callActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //present action sheet
        present(callActionSheet, animated: true, completion: nil)
    }
    
}



