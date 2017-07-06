//
//  EditPetViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class EditPetViewController: UIViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var petKey: String?
    
    //MARK: --outlets
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var editPetName: UITextField!
    @IBOutlet weak var editPetBday: UITextField!
    @IBOutlet weak var editBreed: UITextField!
    @IBOutlet weak var editVaccines: UITextField!
    @IBOutlet weak var editMeds: UITextField!
    @IBOutlet weak var editSpecialIns: UITextField!
    @IBOutlet weak var editVetName: UITextField!
    @IBOutlet weak var editVetPhone: UITextField!
    @IBOutlet weak var editEmergencyContact: UITextField!
    @IBOutlet weak var editEmergencyPhone: UITextField!
    
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get ref to pets
        ref = Database.database().reference().child("pets").child(userID!)
        
        //observer pet info
        ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //populate petModel w/ dictionary
                let pet = PetModel(dictionary: dictionary)
                
                //dev
                print(pet.petName!)
                
                //populate TF with passed values
                self.editPetName.text = pet.petName!
                self.editPetBday.text = pet.birthday!
                self.editBreed.text = pet.breed!
                self.editVaccines.text = pet.vaccines!
                self.editMeds.text = pet.meds!
                self.editSpecialIns.text = pet.specialIns!
                self.editVetName.text = pet.vetName!
                self.editVetPhone.text = pet.vetPhone!
                self.editEmergencyContact.text = pet.emergencyContact!
                self.editEmergencyPhone.text = pet.emergencyPhone!
                
                if let petImgURL = pet.petImage{
                    //dev
                    print(petImgURL)
                    //set image to imageView
                    self.petImageView.loadImageUsingCache(petImgURL)
                }
                
//                print(pet.petKey!)
                
                self.petKey = pet.petKey!
                
            }
        }, withCancel: nil)
        
    }
    
    
    @IBAction func savePetChanges(_ sender: Any) {
        
        //dev
        print("save pet changes")
        print(petKey!)
        
        //get TF values
        let petName = editPetName.text
        let bday = editPetBday.text
        let breed = editBreed.text
        let vaccines = editVaccines.text
        let meds = editMeds.text
        let specialIns = editSpecialIns.text
        let vetName = editVetName.text
        let vetPhone = editVetPhone.text
        let emergencyContact = editEmergencyContact.text
        let emergencyPhone = editEmergencyPhone.text
        
        //populate class w/ TF values
        let updatePet = PetData(petName: petName!, birthday: bday!, breed: breed!, meds: meds!, vaccine: vaccines!, specialInstructions: specialIns!, emergencyContact: emergencyContact!, emergencyPhone: emergencyPhone!, vetName: vetName!, vetPhone: vetPhone!)
        
        //update DB w/ new values
        ref.child(petKey!).updateChildValues(["petName": updatePet.petName, "birthday": updatePet.birthday, "breed": updatePet.breed, "vaccines": updatePet.vaccine, "meds": updatePet.meds, "specialIns": updatePet.specialInstructions, "vetName": updatePet.vetName, "vetPhone": updatePet.vetPhone, "emergencyContact": updatePet.emergencyContact, "emergencyPhone": updatePet.emergencyPhone])
        
        //segue to details, update view w/ new values
        self.performSegue(withIdentifier: "updatePet", sender: self)
    }
    
    @IBAction func cancelPetEdit(_ sender: Any) {
        //dev
        print("canceil pet changes")
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: title, message: "OPEN CAMERA", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
        
    }
}
