//
//  PetRegisterViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/12/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

//TODO: pull user company code to store in pets for query on walker side
class PetRegisterViewController: UIViewController {
    
    //MARK: -- stored properties
    let userID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    var activeField: UITextField?
    
    //refenerce to ownerhomeVC - instantiant ownerhomeVC
    lazy var ownerhomeVC: UIViewController? = {
        //init ownerhomeVC w/ identifier
        let ownerhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "ownerProfile")
        //return vc
        return ownerhomeVC
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var petNameTF: UITextField!
    @IBOutlet weak var bdayTF: UITextField!
    @IBOutlet weak var breedTF: UITextField!
    @IBOutlet weak var medsTF: UITextField!
    @IBOutlet weak var vaccineTF: UITextField!
    @IBOutlet weak var specialInstructionTF: UITextField!
    @IBOutlet weak var emergenctContactTF: UITextField!
    @IBOutlet weak var emergencyPhoneTF: UITextField!
    @IBOutlet weak var vetTF: UITextField!
    @IBOutlet weak var vetPhoneTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dev
        print("testID" + " " + userID!)
        
        //get ref to DB
        self.ref = Database.database().reference().child("pets").child(userID!)
        self.userRef = Database.database().reference().child("users").child(userID!)
        
        //broadcast info and add observer for when keyboard shows and hides
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //set TF delegates
        setTFDelegate()
        
    }
    
    //MARK: -- actions
    @IBAction func addImage(_ sender: UIButton) {
        
        FieldValidation.textFieldAlert("Select Image", message: "Open camera will be in future release", presenter: self)
    }
    
    @IBAction func petSave(_ sender: UIBarButtonItem) {
        
        //retrieve textField text
        let petName = petNameTF.text
        let bday = bdayTF.text
        let breed = breedTF.text
        let meds = medsTF.text
        let vaccine = vaccineTF.text
        let specialIns = specialInstructionTF.text
        let emergencyContact = emergenctContactTF.text
        let emeregencyPhone = emergencyPhoneTF.text
        let vetName = vetTF.text
        let vetPhone = vetPhoneTF.text
        
        //TODO: check text fields are not empty
        //generate key for each pet create - for later release
        let petKey = self.ref.childByAutoId().key
        
        let petData = PetData(petName: petName!, birthday: bday!, breed: breed!, meds: meds!, vaccine: vaccine!, specialInstructions: specialIns!, emergencyContact: emergencyContact!, emergencyPhone: emeregencyPhone!, vetName: vetName!, vetPhone: vetPhone!)
        
        //push create pet to Firebase
        self.ref.child(petKey).setValue(["petName": petData.petName, "birthday": petData.birthday, "breed": petData.breed, "meds": petData.meds, "vaccines": petData.vaccine, "specialIns": petData.specialInstructions, "emergencyContact": petData.emergencyContact, "emergencyPhone": petData.emergencyPhone, "vetName": petData.vetName,"vetPhone": petData.vetPhone, "petKey": petKey, "uid": userID])
        
        //testing to get values on walker side
        self.userRef.updateChildValues(["petName": petData.petName, "petKey": petKey, "emergencyContact": petData.emergencyContact, "emergencyPhone": petData.emergencyPhone])
        
        print("SAVED PET")
        
        self.present(self.ownerhomeVC!, animated: true, completion: nil)
        
    }
    
    //set size of scroll view to the view content size
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 700)
    }
    
}


//MARK: -- extension for keyboard funtionality
extension PetRegisterViewController{
    
    //MARK: -- keyboard editing functionality
    //reference used for this functionality:
    //https://spin.atomicobject.com/2014/03/05/uiscrollview-autolayout-ios/
    func keyboardDidShow(_ notification: Notification) {
        if let activeField = self.activeField, let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    //method to hide keyboard
    func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func setTFDelegate(){
        //set TF delegate to self
        petNameTF.delegate = self
        bdayTF.delegate = self
        breedTF.delegate = self
        medsTF.delegate = self
        vaccineTF.delegate = self
        specialInstructionTF.delegate = self
        emergenctContactTF.delegate = self
        emergencyPhoneTF.delegate = self
        vetTF.delegate = self
        vetPhoneTF.delegate = self
        
    }
}

