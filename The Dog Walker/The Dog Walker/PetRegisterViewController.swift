//
//  PetRegisterViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/12/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

class PetRegisterViewController: UIViewController {
    
    
    //test
    var userID: String?
    
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
    
    
    
    
    @IBAction func addImage(_ sender: UIButton) {
    
        let alert = UIAlertController(title: title, message: "OPEN CAMERA", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener{ auth, user in
            
            //check if user is signed in
            if let user = user {
                //dev
                print("petListener" + " " +  user.uid)
                self.userID = user.uid
                print("UID" + " " + self.userID!)
                
                           }
        }//end of listener

    }
    

}
