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


//TODO: add address to user node (do not nest)
class RegisterViewController: UIViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let users: String = "users"
    var activeField: UITextField?
    
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
    @IBOutlet weak var companyCodeTF: UITextField!
    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create reference to database
        ref = Database.database().reference()
        
        //broadcast info and add observer for when keyboard shows and hides
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //set TF delegate to self
        setTFDelegate()
    }
    
    
    //MARK: -- actions
    @IBAction func addProfileImage(_ sender: UIButton) {
        
        FieldValidation.textFieldAlert("Open Camera", message: "Will present option to take photo or choose from library", presenter: self)
    }
    
    //func to create user and save to FB DB
    func createUser(_ user: User){
        
        //populate class w/ TF text
        let userInfo = Users(firstName: firstNameTF.text! as String, lastName: lastNameTF.text! as String, email: emailTF.text! as String, address: addressTF.text! as String, city: cityTF.text! as String, state: stateTF.text! as String, zipCode: zipCodeTF.text! as String, phoneNumber: phoneTF.text! as String, uid: user.uid, companyCode: companyCodeTF.text! as String)
        
        //check if apt # has value
        if aptTF.text != nil{
            //set value for apt #
            userInfo.aptNumber = aptTF.text! as String
        }
        
        //save & push data to FB DB
        ref.child(users).child(user.uid).setValue(["firstName": userInfo.firstName, "lastName": userInfo.lastName, "email": userInfo.email, "password": passwordTF.text! as String, "phoneNumber": userInfo.phoneNumber, "uid": userInfo.uid, "companyCode": userInfo.companyCode, "companyName": companyNameTF.text! as String, "address": userInfo.address, "city": userInfo.city, "state": userInfo.state, "zipCode": userInfo.zipCode, "aptNumber": userInfo.aptNumber])
    }
    
    //MARK: --segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //auth register flag
        var loginFlag: Bool = false
        
        //check identifier
        if identifier == "register"{
            
            //dev
            print("register segue")
            
            //check textFields are not empty
            if (!FieldValidation.isEmpty(firstNameTF, presenter: self) && !FieldValidation.isEmpty(lastNameTF, presenter: self) && !FieldValidation.isEmpty(emailTF, presenter: self) && !FieldValidation.isEmpty(passwordTF, presenter: self) && !FieldValidation.isEmpty(confirmPasswordTF, presenter: self) && !FieldValidation.isEmpty(addressTF, presenter: self) && !FieldValidation.isEmpty(cityTF, presenter: self) && !FieldValidation.isEmpty(stateTF, presenter: self) && !FieldValidation.isEmpty(zipCodeTF, presenter: self) && !FieldValidation.isEmpty(phoneTF, presenter: self) && !FieldValidation.isEmpty(companyCodeTF, presenter: self)){
                //get emailTF text
                let email = emailTF.text
                let password = passwordTF.text
                
                //auth w/ FB to create user
                Auth.auth().createUser(withEmail: email!, password: password!, completion: {(user, error) in
                    
                    //check if create user failed
                    if let error = error{
                        //present alert failed
                        FieldValidation.textFieldAlert("Email or password invlaid", message: error.localizedDescription, presenter: self)
                        //dev
                        print(error.localizedDescription)
                        return
                    }
                    //create user
                    self.createUser(user!)
                })
                //perform segue
                loginFlag = true
                return loginFlag
                
                
            }//end of empty check
            
        }//end of auth check
        
        //check if canceled
        if identifier == "cancel"{
            //return to login
            loginFlag = true
            return loginFlag
        }
        
        //don't perform segue
        return loginFlag
    }
    
    //set size of scroll view to the view content size
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 850)
    }

}

extension RegisterViewController{
    
    //MARK: --Keyboard editing functionality
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
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        addressTF.delegate = self
        aptTF.delegate = self
        cityTF.delegate = self
        stateTF.delegate = self
        zipCodeTF.delegate = self
        phoneTF.delegate = self
        companyCodeTF.delegate = self
        companyNameTF.delegate = self
    }
    
    
    
}
