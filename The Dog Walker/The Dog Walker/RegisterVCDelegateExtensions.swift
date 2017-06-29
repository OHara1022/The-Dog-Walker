//
//  RegisterVCDelegateExtensions.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/22/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit

extension RegisterViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: -- textFieldDelegate
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
        case firstNameTF:
            lastNameTF.becomeFirstResponder()
            return true
            
        case lastNameTF:
            emailTF.becomeFirstResponder()
            return true
            
        case emailTF:
            passwordTF.becomeFirstResponder()
            return true
            
        case passwordTF:
            confirmPasswordTF.becomeFirstResponder()
            return true
            
        case confirmPasswordTF:
            addressTF.becomeFirstResponder()
            return true
            
        case addressTF:
            aptTF.becomeFirstResponder()
            return true
            
        case aptTF:
            cityTF.becomeFirstResponder()
            return true
            
        case cityTF:
            stateTF.becomeFirstResponder()
            return true
            
        case stateTF:
            zipCodeTF.becomeFirstResponder()
            return true
            
        case zipCodeTF:
            phoneTF.becomeFirstResponder()
            return true
            
        case phoneTF:
             companyCodeTF.becomeFirstResponder()
             return true
        case companyCodeTF:
            companyNameTF.becomeFirstResponder()
            return true
        case companyNameTF:
            self.view.endEditing(true)//dismiss keyboard
            return true
        default:
            break
        }
        //else return false
        return false
    }
    
    //MARK -- imagePickerDelegate / navigationDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //get image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            //set image
            profileImage.image = image
        }
        
        //dismiss imagePickerVC
        dismiss(animated: true, completion: nil)
    }
    
    //dismiss image picker if canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss imagePickerVC
        dismiss(animated: true, completion: nil)
    }

    
}
