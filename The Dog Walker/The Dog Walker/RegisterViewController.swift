//
//  RegisterViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/12/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    
    //MARK: -- outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var aptTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var companyTV: UITextField!
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let users: String = "users"
    
    //refenerce to walker home VC - instantiant walkerHome VC
    lazy var ownerVC: UIViewController? = {
        //init walkerHomeVC w/ identifier
        let ownerVC = self.storyboard?.instantiateViewController(withIdentifier: "petReg")
        //return vc
        return ownerVC
    }()
    
    //refenerce to walker home VC - instantiant walkerHome VC
    lazy var homeVC: UIViewController? = {
        //init walkerHomeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "walker")
        //return vc
        return homeVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //create reference to database
        ref = Database.database().reference()
    }
    
    func saveAddress(_ addressInfo: AddressInfo, databaseRef: DatabaseReference, user: Users){
        databaseRef.child(users).child(user.uid).child("address").setValue(["address": addressInfo.address, "aptNumber": addressInfo.aptNumber, "city": addressInfo.city, "state": addressInfo.state, "zipCode": addressInfo.zipCode])
        
    }
    
    func createUser(_ user: User){
        
        let addressInfo = AddressInfo(address: addressTF.text! as String, aptNumber: aptTF.text! as String, city: cityTF.text! as String, state: stateTF.text! as String, zipCode: zipCodeTF.text! as String)
        
        let userInfo = Users(firstName: firstNameTF.text! as String, lastName: lastNameTF.text! as String, email: emailTF.text! as String, address: addressInfo, phoneNumber: phoneTF.text! as String, uid: user.uid)
        
        ref.child(users).child(user.uid).setValue(["firstName": userInfo.firstName, "lastName": userInfo.lastName, "email": userInfo.email, "password": passwordTF.text! as String, "phoneNumber": userInfo.phoneNumber, "uid": userInfo.uid])
        
        saveAddress(userInfo.address, databaseRef: self.ref, user: userInfo)
        
    }
    
    //MARK: -- actions
    @IBAction func addProfileImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: title, message: "OPEN CAMERA", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
//    @IBAction func saveReg(_ sender: Any) {
//        
//        let email = emailTF.text
//        let password = passwordTF.text
//        
//        Auth.auth().createUser(withEmail: email!, password: password!, completion: {(user, error) in
//            
//            if let error = error{
//                
//                FieldValidation.textFieldAlert("Invalid Information", message: error.localizedDescription, presenter: self)
//                //dev
//                print(error.localizedDescription)
//                return
//            }
//            self.createUser(user!)
//        })
//        
//        if companyTV.text == "walker"{
//            
//            present(homeVC!, animated: true, completion: nil)
//            
//            
//        }
//        
//        if companyTV.text == "owner"{
//            
//            present(ownerVC!, animated: true, completion: nil)
//            
//        }
//        
//        
//        
//    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        
        //auth register flag
        var loginFlag: Bool = false
        
        //check identifier
        if identifier == "register"{
            
            //dev
            print("register segue")
            
            //check textFields are not empty
            //            if (!FieldValidation.isEmpty(firstNameTF, presenter: self) && !FieldValidation.isEmpty(lastNameTF, presenter: self) && !FieldValidation.isEmpty(emailTF, presenter: self) && !FieldValidation.isEmpty(passwordTF, presenter: self) && !FieldValidation.isEmpty(confirmPasswordTF, presenter: self) && !FieldValidation.isEmpty(addressTF, presenter: self) && !FieldValidation.isEmpty(cityTF, presenter: self) && !FieldValidation.isEmpty(stateTF, presenter: self) && !FieldValidation.isEmpty(zipCodeTF, presenter: self) && !FieldValidation.isEmpty(phoneTF, presenter: self)){
            
            let email = emailTF.text
            let password = passwordTF.text
            
            Auth.auth().createUser(withEmail: email!, password: password!, completion: {(user, error) in
                
                if let error = error{
                    
                    FieldValidation.textFieldAlert("Invalid Information", message: error.localizedDescription, presenter: self)
                    //dev
                    print(error.localizedDescription)
                    return
                }
                self.createUser(user!)
            })
            
//            if companyTV.text == "walker"{
            
                loginFlag = true
                return loginFlag
//            }
            
//            if companyTV.text == "owner"{
//                
//                loginFlag = true
//                
//                present(ownerVC!, animated: true, completion: nil)
//                return loginFlag
//            }
            
            
            //            }//end of empty check
            
        }//end of auth check
        
        //check if canceled
        if identifier == "cancel"{
            //return to login
            loginFlag = true
            return loginFlag
        }
        
        return loginFlag
    }
    
    //}//end of field check
}

