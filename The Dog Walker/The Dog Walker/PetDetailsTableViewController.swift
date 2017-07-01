//
//  PetDetailsTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class PetDetailsTableViewController: UITableViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    //MARK: -- outlets
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var vaccineLabel: UILabel!
    @IBOutlet weak var medLabel: UILabel!
    @IBOutlet weak var specialInsLabel: UILabel!
    @IBOutlet weak var vetNameLabel: UILabel!
    @IBOutlet weak var vetPhoneLabel: UILabel!
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get ref to pets
        ref = Database.database().reference().child("pets").child(userID!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                
                //populate labels with passed values
                self.petNameLabel.text = pet.petName!
                self.dateLabel.text = pet.birthday!
                self.breedLabel.text = pet.breed!
                self.vaccineLabel.text = pet.vaccines!
                self.medLabel.text = pet.meds!
                self.specialInsLabel.text = pet.specialIns!
                self.vetNameLabel.text = pet.vetName!
                self.vetPhoneLabel.text = pet.vetPhone!
                
                if let petImgURL = pet.petImage{
                    //dev
                    print(petImgURL)
                    //set image to imageView
                    self.petImageView.loadImageUsingCache(petImgURL)
                }
                
            }
        }, withCancel: nil)

    }
    
    
    //MARK: -- actions
    @IBAction func addPet(_ sender: UIButton) {
        
        FieldValidation.textFieldAlert("Add Pet", message: "Add Pet will be in future release", presenter: self)
        
    }
}
