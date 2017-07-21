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
    var loginRef: DatabaseReference!
    //    let userID = Auth.auth().currentUser?.uid
    
    //refenerce to walker home VC - instantiant walkerHome VC
    lazy var walkerhomeVC: UIViewController? = {
        //init walkerHomeVC w/ identifier
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "walkerHome")
        //return vc
        return homeVC
    }()
    
    lazy var ownerhomeVC: UIViewController? = {
        //init ownerhomeVC w/ identifier
        let ownerhomeVC = self.storyboard?.instantiateViewController(withIdentifier: "ownerHome")
        //return vc
        return ownerhomeVC
    }()
    
    //MARK: -- outlets
    @IBOutlet weak var emailLoginTF: UITextField!
    @IBOutlet weak var passwordLoginTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: -- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //login ref for persitant login
        self.loginRef = Database.database().reference().child(users)
        
        //set textFieldDelegate to self
        emailLoginTF.delegate = self
        passwordLoginTF.delegate = self
        
    }
    
    //MARK: --viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //clear textFields
        self.emailLoginTF.text = ""
        self.passwordLoginTF.text = ""
        
        //check auth state
        if Auth.auth().currentUser != nil{
            //listen for changes in auth state
            Auth.auth().addStateDidChangeListener { (auth, user) in
                
                if let user = user{
                    //dev
                    print("LOGGED IN" + " " + user.email!)
                    print("AUTH" + " " + (auth.currentUser?.uid)!)
                    
                    //obserserve event to check role on login
                    self.loginRef.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        //get snapshot as dictionary
                        if let dictionary = snapshot.value as? [String: AnyObject]{
                            
                            //get userModal w/ dictionary vallues
                            let user = UserModel(dictionary: dictionary)
                            
                            //get user roleID
                            let roleID = user.roleID
                            
                            //check role id
                            if roleID == "Walker"{
                                
                                //present walker homeVC
                                self.present(self.walkerhomeVC!, animated: true, completion: nil)
                                
                            }else if roleID == "Owner"{
                                
                                //present pet owner homeVC
                                self.present(self.ownerhomeVC!, animated: true, completion: nil)
                            }
                        }
                        
                    }, withCancel: nil)
                }
            }
        }
    }
    
    //MARK: -- actions
    @IBAction func loginUserBtn(_ sender: Any) {
        
        //check that fields are not empty
        if (FieldValidation.isEmpty(emailLoginTF, presenter: self) && FieldValidation.isEmpty(passwordLoginTF, presenter: self)){
        }
        
        //sign in user w/ email & password
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
                self.ref = Database.database().reference().child(users).child(user.uid)
                
                //obserserve event to check role on login
                self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //get snapshot as dictionary
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        
                        //get userModal w/ dictionary vallues
                        let user = UserModel(dictionary: dictionary)
                        
                        //get user roleID
                        let roleID = user.roleID
                        
                        //check role id
                        if roleID == "Walker"{
                            
                            //present walker homeVC
                            self.present(self.walkerhomeVC!, animated: true, completion: nil)
                            
                        }else if roleID == "Owner"{
                            
                            //present pet owner homeVC
                            self.present(self.ownerhomeVC!, animated: true, completion: nil)
                        }
                    }
                    
                }, withCancel: nil)
                
            }
            //disable login until user is logged in
            self.loginBtn.isEnabled = false
        }
    }
    
    
    //forgotPasword
    @IBAction func forgotPassword(_ sender: UIButton) {
        
        //create alert controller
        let alert = UIAlertController(title: "Reset Password", message: "Please enter email address", preferredStyle: .alert)
        
        //add textField to alert
        alert.addTextField { (textField) in
            
            //set placeholder text
            textField.placeholder = "Enter email address"
        }
        
        //add action to alert
        alert.addAction(UIAlertAction(title: "Send Email", style: .default, handler: { (action) in
            
            //get alert textField
            if let textField = alert.textFields{
                //set array of TF info
                let fields = textField as [UITextField]
                //get text from TF
                let enteredText = fields[0].text
                //dev
                print(enteredText!)
                
                //send reset password email w/ FB Auth
                Auth.auth().sendPasswordReset(withEmail: enteredText!, completion: { (error) in
                    
                    //check if email reset failed
                    if let error = error{
                        //dev
                        print(error.localizedDescription)
                        //alert user of send email error
                        FieldValidation.textFieldAlert("Email address not registered", message: "Please register for an account", presenter: self)
                        return
                    }
                })
            }
            
        }))
        
        //add alert action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //present alert
        present(alert, animated: true)
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
