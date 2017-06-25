//
//  LoginViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/5/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: -- stored properties
    var ref: DatabaseReference!
    var roleID: String?
    
    //refenerce to walker home VC - instantiant walkerHome VC
    lazy var walkerhomeVC: UIViewController? = {
        //init walkerHomeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "walkerHome")
        //return vc
        return homeVC
    }()
    
    //refenerce to ownerhomeVC - instantiant ownerhomeVC
    lazy var ownerhomeVC: UIViewController? = {
        //init ownerhomeVC w/ identifier
        let ownerhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "ownerHome")
        //return vc
        return ownerhomeVC
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var emailLoginTF: UITextField!
    @IBOutlet weak var passwordLoginTF: UITextField!
    
    //MARK: -- viewDidLoad
    //TODO: get snapshot of users, check role (walker/owner) - transition to proper homeVC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set textFieldDelegate to self
        emailLoginTF.delegate = self
        passwordLoginTF.delegate = self
        
        //TODO: transition depending on roleID - crashes if code implemented with auth.signin w/ FB (research for later release)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let user = user{
                //dev
                print("LOGGED IN" + " " + user.email!)
            }
        }
    }
    
    //MARK: --viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //clear textFields
        self.emailLoginTF.text = ""
        self.passwordLoginTF.text = ""
    }
    
    //MARK: -- actions
    @IBAction func loginTest(_ sender: UIButton) {
        
        //check that fields are not empty
        if (!FieldValidation.isEmpty(emailLoginTF, presenter: self) && !FieldValidation.isEmpty(passwordLoginTF, presenter: self)){
            
            Auth.auth().signIn(withEmail: emailLoginTF.text!, password: passwordLoginTF.text!) { (user, error) in
                
                //check if email failed
                if let error = error{
                    //dev
                    print(error.localizedDescription)
                    //alert user of login error
                    FieldValidation.textFieldAlert("Invalid Information", message: error.localizedDescription, presenter: self)
                    return
                }
                //optional bind to ensure we have user
                if let user = user{
                    
                    //set ref to DB
                    self.ref = Database.database().reference().child("users").child(user.uid)
                    
                    //obserserve event to check role on login
                    self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        //get snapshot of users
                        let dic = snapshot.value as? NSDictionary
                        
                        //get value from snapshot
                        let id = dic?.value(forKey: "roleID") as? String
                        //dev
                        print(id!)
                        //set roldID
                        self.roleID = id
                        
                        //check role id
                        if self.roleID == "Walker"{
                            
                            //present walker homeVC
                            self.present(self.walkerhomeVC!, animated: true, completion: nil)
                            
                        }else if self.roleID == "Owner"{
                            
                            //present pet owner homeVC
                            self.present(self.ownerhomeVC!, animated: true, completion: nil)
                            
                        }
                    })
                    
                }
            }
        }
        
    }
    
    //TODO: display alert with edit text - send email reset w/ firebase auth
    @IBAction func forgotPassword(_ sender: UIButton) {
        
        //alert user
        FieldValidation.textFieldAlert("Forgot Password?", message: "Will send recover email in furture release", presenter: self)
        
    }
    
}


//MARK: -- extension TF delegate
extension LoginViewController: UITextFieldDelegate{
    
    
    //call TF shouldReturn method to move to next field on return selection
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //check emailTf
        if (textField == emailLoginTF){
            passwordLoginTF.becomeFirstResponder()//switch to password TF
            return true
        }
        
        //check passwordTF
        if (textField == passwordLoginTF){
            self.view.endEditing(true)//dismiss keyboard
            return true
        }
        return false
    }

    
}
