//
//  PetRegisterViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/12/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class PetRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: -- stored properties
    let userID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    var activeField: UITextField?
    var dateHolderString: String = ""
    var datePicker: UIDatePicker!
    
    //refenerce to ownerhomeVC - instantiant ownerhomeVC
    lazy var ownerhomeVC: UIViewController? = {
        //init ownerhomeVC w/ identifier
        let ownerhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "ownerProfile")
        //return vc
        return ownerhomeVC
    }()
    
    //refenerce to ownerhomeVC - instantiant ownerhomeVC
    lazy var homeVC: UIViewController? = {
        //init ownerhomeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "home")
        //return vc
        return homeVC
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var petImage: UIImageView!
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
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set radius so image is circle
        let radius = self.petImage.frame.height / 2
        self.petImage.layer.cornerRadius = radius
        self.petImage.layer.masksToBounds = true
        self.petImage.contentMode = .scaleAspectFill
        self.petImage.clipsToBounds = true
        
        //dev
        print("testID" + " " + userID!)
        
        //get ref to DB
        self.ref = Database.database().reference().child("pets").child(userID!)
        
        //init date picker & set mode, inputView, & target
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        bdayTF.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        pickerItem(title: "Birthday", textField: bdayTF, selector:  #selector(PetRegisterViewController.doneDatePickerPressed))

        //broadcast info and add observer for when keyboard shows and hides
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //set TF delegates
        setTFDelegate()
    
    }
    
    //MARK: -- actions
    @IBAction func cancel(_ sender: Any) {
        
        //sign user out w/ firebase auth
        try! Auth.auth().signOut()
        self.present(homeVC!, animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        //present image option for camera or library
        presentImgOptions()
        
    }
    
    @IBAction func petSave(_ sender: UIBarButtonItem) {
        
        //check that fields are not empty
        if (!FieldValidation.isEmpty(petNameTF, presenter: self) && !FieldValidation.isEmpty(bdayTF, presenter: self) && !FieldValidation.isEmpty(breedTF, presenter: self) && !FieldValidation.isEmpty(medsTF, presenter: self) && !FieldValidation.isEmpty(vaccineTF, presenter: self) && !FieldValidation.isEmpty(emergenctContactTF, presenter: self) && !FieldValidation.isEmpty(emergencyPhoneTF, presenter: self) && !FieldValidation.isEmpty(vetTF, presenter: self) && !FieldValidation.isEmpty(vetPhoneTF, presenter: self)){
            
            //retrieve textField text
            let petName = petNameTF.text
//            let bday = bdayTF.text
            let breed = breedTF.text
            let meds = medsTF.text
            let vaccine = vaccineTF.text
            let specialIns = specialInstructionTF.text
            let emergencyContact = emergenctContactTF.text
            let emeregencyPhone = emergencyPhoneTF.text
            let vetName = vetTF.text
            let vetPhone = vetPhoneTF.text
            
            //generate key for each pet created
            let petKey = self.ref.childByAutoId().key
            
            //populate class with TF text
            let petData = PetData(petName: petName!, birthday: dateHolderString, breed: breed!, meds: meds!, vaccine: vaccine!, specialInstructions: specialIns!, emergencyContact: emergencyContact!, emergencyPhone: emeregencyPhone!, vetName: vetName!, vetPhone: vetPhone!)
            
            //ref to store pet images
            let storageRef = Storage.storage().reference().child("petImages").child("\(userID!).jpeg")
            
            //compress images
            if let uploadImage = UIImageJPEGRepresentation(self.petImage.image!, 0.6){
                
                //get data
                storageRef.putData(uploadImage, metadata: nil, completion: { (metadata, error) in
                    //check if create user failed
                    if let error = error{
                        //present alert failed
                        FieldValidation.textFieldAlert("Image Storage Error", message: error.localizedDescription, presenter: self)
                        //dev
                        print(error.localizedDescription)
                        return
                    }
                    
                    //get image url
                    if let petImgURL = metadata?.downloadURL()?.absoluteString{
                        //dev
                        print(petImgURL)
                        
                        //save image url
                        self.ref.child(petKey).updateChildValues(["petImage": petImgURL])
                    }
                })
            }
            
            //push create pet to Firebase
            self.ref.child(petKey).setValue(["petName": petData.petName, "birthday": petData.birthday, "breed": petData.breed, "meds": petData.meds, "vaccines": petData.vaccine, "specialIns": petData.specialInstructions, "emergencyContact": petData.emergencyContact, "emergencyPhone": petData.emergencyPhone, "vetName": petData.vetName,"vetPhone": petData.vetPhone, "petKey": petKey, "uid": userID])
            
            //dev
            print("SAVED PET")
            
            //present ownerVC
            self.present(self.ownerhomeVC!, animated: true, completion: nil)
        }
    }
    
    //set size of scroll view to the view content size
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 700)
    }
    
}

