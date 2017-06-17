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
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        //add action
        alert.addAction(alertAction)
        //present alert
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
    
}
