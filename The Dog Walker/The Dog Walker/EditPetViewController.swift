//
//  EditPetViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class EditPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: -- viewDidLoad
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
                
                if let petImgURL = pet.petImage{
                    //dev
                    print(petImgURL)
                    //set image to imageView
                    self.petImageView.loadImageUsingCache(petImgURL)
                }
                
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
                
                if self.editSpecialIns.text == ""{
                    self.editSpecialIns.text = "None"
                }
                
                //                print(pet.petKey!)
                
                self.petKey = pet.petKey!
                
            }
        }, withCancel: nil)
    }
    
    //set size of scroll view to the view content size
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 900)
    }
    
    //MARK: --actions
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
        
      presentImgOptions()
        
    }
}

extension EditPetViewController{
    
    //MARK: -- image functionality
    func presentImgOptions(){
        
        //create action sheet
        let photoActionSheet = UIAlertController(title: "Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        //add actions
        photoActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //present action sheet
        present(photoActionSheet, animated: true, completion: nil)
    }
    
    
    //MARK -- imagePickerDelegate / navigationDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //get image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
           
            //set image
            petImageView.image = image
            
        }
        
        //dismiss imagePickerVC
        dismiss(animated: true, completion: nil)
        
    }
    
    //dismiss image picker if canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss imagePickerVC
        dismiss(animated: true, completion: nil)
    }
    


}
