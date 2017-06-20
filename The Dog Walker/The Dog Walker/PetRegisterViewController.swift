//
//  PetRegisterViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/12/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class PetRegisterViewController: UIViewController {
    
    //MARK: -- stored properties
    let userID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("testID" + " " + userID!)
        
//        Auth.auth().addStateDidChangeListener{ auth, user in
//            
//            //check if user is signed in
//            if let user = user {
//                //dev
//                print("pet!!!" + " " +  user.uid)
//              
//              
//            }
//        }//end of listener
        
         self.ref = Database.database().reference().child("pets").child(userID!)
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
        
        print("SAVED PET")
        
        self.present(self.ownerhomeVC!, animated: true, completion: nil)
        
    }

    
    
}
