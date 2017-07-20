//
//  FieldValidation.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/17/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit

class FieldValidation{
    
    //MARK: -- textField alert
    class func textFieldAlert(_ title: String, message: String, presenter: UIViewController){
        
        //alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //alert action
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        presenter.present(alert, animated: true)
        
    }
    
    //MARK: -- empty check
    class func isEmpty(_ textField: UITextField, presenter: UIViewController) -> Bool{
        
        if (textField.text?.isEmpty)! {
            //alert user
            textFieldAlert("Missing Information", message: "No Empty Fields", presenter: presenter)
            return true
        }
        return false
    }
    
    //US - Zipcode Validation
    class func isValidZipCode(_ zipcodeTV: UITextField, presenter: UIViewController) -> Bool {
        
        //zipcode holder
        let zipcode: String = zipcodeTV.text!
        
        let zipCodeRegex = "^\\d{5}([\\-]?\\d{4})?$"	//00000
        let zipCodeTest = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
        let evaluateZipCode = zipCodeTest.evaluate(with: zipcode)
        //Invalid Zipcode
        if(!evaluateZipCode) {
            //alert user zipcode is invalid
            textFieldAlert("Zipcode Invalid", message: "Please enter a valid US zipcode", presenter: presenter)
            return false
        }
        //Valid Zipcode
        return true
    }
    
    //MARK: --Valid email
    //func check valid email
    class func validEmail(_ textField: UITextField, presenter: UIViewController) -> Bool{
        
        //regEX to check for valid email
        let emailValidation = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}")
        
        //evaluate that email is valid
        if (emailValidation.evaluate(with: textField.text!)) {
            //if email valid proceed
            return true
        }
        
        //alert user email is invalid
        textFieldAlert("Email", message: "Invalid Email", presenter: presenter)
        return false
    }
    
    //MARK: --Valid password
    //func check valid password, firebase password must be six chararcters
    class func validPassword(textField: UITextField, presenter: UIViewController) -> Bool{
        
        //is password less then 6 characters alert user
        if (textField.text!.characters.count < 6) {
            
            //alert user password is invalid
            textFieldAlert("Password", message: "Minimum of 6 password characters" , presenter: presenter)
            return false
        }
        return true
    }


}
