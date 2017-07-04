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

class RegisterViewController: UIViewController{
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    let users: String = "users"
    var activeField: UITextField?
    var statePicker: UIPickerView!
    var stateHolderString: String = ""
    
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
        
        //state pickerView
        statePicker = UIPickerView()
        statePicker.tag = 0
        statePicker.dataSource = self
        statePicker.delegate = self
        stateTF.delegate = self
        stateTF.inputView = statePicker
        
        //set picker items
        pickerItem(title: "State", textField: stateTF, selector: #selector(RegisterViewController.doneSelected))
    }
    
 
    //MARK: -- actions
    @IBAction func addProfileImage(_ sender: UIButton) {
        
        //present image action sheet
        presentImgOptions()
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

