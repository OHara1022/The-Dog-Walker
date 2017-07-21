//
//  EditOwnerViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/15/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class EditOwnerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var petRef: DatabaseReference!
    var companyCode: String?
    var petKey: String?
    var activeField: UITextField?
    let userID = Auth.auth().currentUser?.uid
    
    //MARK: --outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editFirstName: UITextField!
    @IBOutlet weak var editLastName: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editAddress: UITextField!
    @IBOutlet weak var editAptNum: UITextField!
    @IBOutlet weak var editCity: UITextField!
    @IBOutlet weak var editState: UITextField!
    @IBOutlet weak var editZipCode: UITextField!
    @IBOutlet weak var editPhoneNum: UITextField!
    @IBOutlet weak var editEmergencyContact: UITextField!
    @IBOutlet weak var editEmergencyPhoneNum: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set DB reference
        ref = Database.database().reference().child(users).child(userID!)
        petRef = Database.database().reference().child(pets).child(userID!)
        
        //broadcast info and add observer for when keyboard shows and hides
        NotificationCenter.default.addObserver(self, selector: #selector(EditOwnerViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditOwnerViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //set TF delegate
        setTFDelegate()
        //set observer for users
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //set snaopshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //print(snapshot)
                
                //get user data as dictionary
                let user = UserModel(dictionary: dictionary)
                
                //dev
                print(user.firstName!)
                
                if let profileImgURL = user.profileImage{
                    
                    print(profileImgURL)
                    
                    self.profileImage.loadImageUsingCache(profileImgURL)
                }
                
                //populate label w/ data from FB
                self.editFirstName.text = user.firstName!
                self.editLastName.text = user.lastName!
                self.editEmail.text = user.email!
                self.editAddress.text = user.address!
                self.editAptNum.text = user.aptNumber!
                self.editCity.text = user.city!
                self.editState.text = user.state!
                self.editZipCode.text = user.zipCode!
                self.editPhoneNum.text = user.phoneNumber!
                
                self.companyCode = user.companyCode!
                
            }
            
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        //observer for pet info
        petRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            //get snapshot as dictionary
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                //dev
                //                print(snapshot)
                
                //populate petModel w/ dictionary data
                let pet = PetModel(dictionary: dictionary)
                
                //dev
                print(pet.emergencyContact!)
                
                self.petKey = pet.petKey!
                
                self.editEmergencyContact.text = pet.emergencyContact!
                self.editEmergencyPhoneNum.text = pet.emergencyPhone!
            }
            
        }, withCancel: nil)
        
    }
    
    //MARK: --actions
    @IBAction func saveOwnerChanges(_ sender: Any) {
        
        //dev
        print("save owner changes")
        
        //get TF text
        let firstName = editFirstName.text
        let lastName = editLastName.text
        let email = editEmail.text
        let address = editAddress.text
        let aptNum = editAptNum.text
        let city = editCity.text
        let state = editState.text
        let zipCode = editZipCode.text
        let phoneNum = editPhoneNum.text
        
        //populate user class w/ new values
        let updateProfile = Users(firstName: firstName!, lastName: lastName!, email: email!, address: address!, city: city!, state: state!, zipCode: zipCode!, phoneNumber: phoneNum!, uid: userID!, companyCode: companyCode!)
        
        //check if apt has value
        if editAptNum.text != nil{
            //set apt # text
            updateProfile.aptNumber = aptNum!
        }
        
        //update database w/ new values
        ref.updateChildValues(["firstName": updateProfile.firstName, "lastName": updateProfile.lastName, "email": updateProfile.email, "phoneNumber": updateProfile.phoneNumber, "uid": updateProfile.uid, "companyCode": updateProfile.companyCode, "address": updateProfile.address, "city": updateProfile.city, "state": updateProfile.state, "zipCode": updateProfile.zipCode, "aptNumber": updateProfile.aptNumber!])
        
        petRef.child(petKey!).updateChildValues(["emergencyContact": editEmergencyContact.text!, "emergencyPhone" : editEmergencyPhoneNum.text!])
        
        //segue to details, update view w/ new values
        self.performSegue(withIdentifier: "updateProfile", sender: self)
    }

    @IBAction func cancelEditOwner(_ sender: Any) {
        
        //dev
        print("cancel owner changes")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        //present camera options
        presentImgOptions()
    }
}
