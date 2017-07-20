//
//  WalkerEditProfileViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class WalkerEditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var companyCode: String?
    var companyName: String?
    
    //MARK: --outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editFirstNameTF: UITextField!
    @IBOutlet weak var editLastNameTF: UITextField!
    @IBOutlet weak var editEmailTF: UITextField!
    @IBOutlet weak var editAddressTF: UITextField!
    @IBOutlet weak var editAptNumTF: UITextField!
    @IBOutlet weak var editCityTF: UITextField!
    @IBOutlet weak var editStateTF: UITextField!
    @IBOutlet weak var editZipCodeTF: UITextField!
    @IBOutlet weak var editPhoneNumTF: UITextField!
    @IBOutlet weak var editCompanyNameTF: UITextField!
    
    
    //MARK: --viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set DB reference
        ref = Database.database().reference().child("users").child(userID!)
        
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
                    
                    //dev
                    print(profileImgURL)
                    
                    //set profile image
                    self.profileImage.loadImageUsingCache(profileImgURL)
                }
                
                //populate label w/ data from FB
                self.editFirstNameTF.text = user.firstName!
                self.editLastNameTF.text = user.lastName!
                self.editEmailTF.text = user.email!
                self.editAddressTF.text = user.address!
                self.editAptNumTF.text = user.aptNumber!
                self.editCityTF.text = user.city!
                self.editStateTF.text = user.state!
                self.editZipCodeTF.text = user.zipCode!
                self.editPhoneNumTF.text = user.phoneNumber!
                self.companyCode = user.companyCode!
                
                //check for company name
                if user.companyName != nil{
                    //set company name to TF
                    self.editCompanyNameTF.text = user.companyName!
                }
            }
            
        }, withCancel: nil)
    }
    
    
    //MARK: --actions
    @IBAction func saveProfileChanges(_ sender: Any) {
        
        let firstName = editFirstNameTF.text
        let lastName = editLastNameTF.text
        let email = editEmailTF.text
        let address = editAddressTF.text
        let aptNum = editAptNumTF.text
        let city = editCityTF.text
        let state = editStateTF.text
        let zipCode = editZipCodeTF.text
        let phoneNum = editPhoneNumTF.text
        let companyName = editCompanyNameTF.text
        
        let updateProfile = Users(firstName: firstName!, lastName: lastName!, email: email!, address: address!, city: city!, state: state!, zipCode: zipCode!, phoneNumber: phoneNum!, uid: userID!, companyCode: companyCode!)
        
        if editAptNumTF.text != nil{
            
            updateProfile.aptNumber = aptNum!
        }
        
        if editCompanyNameTF.text != nil{
            
            updateProfile.companyName = companyName!
        }
        
        ref.updateChildValues(["firstName": updateProfile.firstName, "lastName": updateProfile.lastName, "email": updateProfile.email, "phoneNumber": updateProfile.phoneNumber, "uid": updateProfile.uid, "companyCode": updateProfile.companyCode, "address": updateProfile.address, "city": updateProfile.city, "state": updateProfile.state, "zipCode": updateProfile.zipCode, "aptNumber": updateProfile.aptNumber!, "companyName": updateProfile.companyName!])
        
        //segue to details, update view w/ new values
        self.performSegue(withIdentifier: "updateWalker", sender: self)

    }
    

    
    @IBAction func cancelEdit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        //present image options
        presentImgOptions()
    }


}
