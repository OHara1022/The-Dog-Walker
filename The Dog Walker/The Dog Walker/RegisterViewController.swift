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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //create reference to database
        ref = Database.database().reference()
    }
    
    
    //MARK: -- actions
    @IBAction func addProfileImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: title, message: "OPEN CAMERA", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        //return to login
        dismiss(animated: true, completion: nil)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        
        //auth register flag
        var loginFlag: Bool = false
        
        //check identifier
        if identifier == "register"{
            
            //dev
            print("register segue")
            
            //check textFields are not empty
            if (!FieldValidation.isEmpty(firstNameTF, presenter: self) && !FieldValidation.isEmpty(lastNameTF, presenter: self) && !FieldValidation.isEmpty(emailTF, presenter: self) && !FieldValidation.isEmpty(passwordTF, presenter: self) && !FieldValidation.isEmpty(confirmPasswordTF, presenter: self) && !FieldValidation.isEmpty(addressTF, presenter: self) && !FieldValidation.isEmpty(cityTF, presenter: self) && !FieldValidation.isEmpty(stateTF, presenter: self) && !FieldValidation.isEmpty(zipCodeTF, presenter: self) && !FieldValidation.isEmpty(phoneTF, presenter: self)){
                
                loginFlag = true
                return loginFlag                
                
            }//end of empty check
          
        }
        
        return loginFlag
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
