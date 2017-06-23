//
//  PetRegisterVCDelegateExtenstions.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/23/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit

extension PetRegisterViewController: UITextFieldDelegate{
    //call textfieldDidBeginEditing for keyboard functionality
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    //call textfieldDidEndEditing for keyboard functionality
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    //call textFieldShouldReturn method to move to next field on return selection
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //switch text fields to move to next on return selection
        switch textField {
            
        //each case switches what textfield should respond next
        case petNameTF:
            bdayTF.becomeFirstResponder()
            return true
            
        case bdayTF:
            breedTF.becomeFirstResponder()
            return true
            
        case breedTF:
            medsTF.becomeFirstResponder()
            return true
            
        case medsTF:
            vaccineTF.becomeFirstResponder()
            return true
            
        case vaccineTF:
            specialInstructionTF.becomeFirstResponder()
            return true
            
        case specialInstructionTF:
            emergenctContactTF.becomeFirstResponder()
            return true
            
        case emergenctContactTF:
            emergencyPhoneTF.becomeFirstResponder()
            return true
            
        case emergencyPhoneTF:
            vetTF.becomeFirstResponder()
            return true
            
        case vetTF:
            vetPhoneTF.becomeFirstResponder()
            return true
            
        case vetPhoneTF:
            self.view.endEditing(true)//dismiss keyboard
            return true
        default:
            break
        }
        //else return false
        return false
    }
    
    
    
}
