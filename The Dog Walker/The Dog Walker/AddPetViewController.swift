//
//  AddPetViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 7/29/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class AddPetViewController: UIViewController {
    
    //MARK: --stored properties
    var ref: DatabaseReference!
    var petRef: DatabaseReference!
    var activeField: UITextField?
    var petKey: String?
    var specialIns: String?
    var vetName: String?
    var vetPhone: String?
    let userID = Auth.auth().currentUser?.uid
    
    
    //MARK: --outlets
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameTF: UITextField!
    @IBOutlet weak var bdayTF: UITextField!
    @IBOutlet weak var breedTF: UITextField!
    @IBOutlet weak var vaccineTF: UITextField!
    @IBOutlet weak var medsTF: UITextField!
    
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get ref to DB
        self.ref = Database.database().reference().child(pets).child(userID!)
        
        //observer pet info
        //        ref.observeSingleEvent(of: .childAdded, with: { (snapshot) in
        //
        //            //get snapshot as dictionary
        //            if let dictionary = snapshot.value as? [String: AnyObject]{
        //
        //                //dev
        //                //print(snapshot)
        //
        //                //populate petModel w/ dictionary
        //                let pet = PetModel(dictionary: dictionary)
        //                self.specialIns = pet.specialIns!
        //                self.vetName = pet.vetName!
        //                self.vetPhone = pet.vetPhone!
        //
        //                if self.specialIns == ""{
        //                    self.specialIns = "None"
        //                }
        //            }
        //        }, withCancel: nil)
    }
    
    
    //MARK: --actions
    @IBAction func cancelAddPet(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePetBtn(_ sender: Any) {
        
        //check for emty fields
        if (!FieldValidation.isEmpty(petNameTF, presenter: self) && !FieldValidation.isEmpty(bdayTF, presenter: self) && !FieldValidation.isEmpty(breedTF, presenter: self) && !FieldValidation.isEmpty(vaccineTF, presenter: self) && !FieldValidation.isEmpty(medsTF, presenter: self)) {
            
            //get TF text
            let petName = petNameTF.text
            let bday = bdayTF.text
            let breed = breedTF.text
            let vaccines = vaccineTF.text
            let meds = medsTF.text
            
            //generate new pet key
            self.petKey = self.ref.childByAutoId().key
            
            self.ref.child(petKey!).setValue(["petName" : petName, "birthday" : bday, "breed": breed, "vaccines" : vaccines, "meds" : meds, "petKey": petKey, "uid": userID])
            
            print("SAVE PET")
            
//           dismiss(animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    
}
