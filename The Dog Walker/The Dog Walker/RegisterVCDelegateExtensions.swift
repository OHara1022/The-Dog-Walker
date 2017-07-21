//
//  RegisterVCDelegateExtensions.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/22/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//MARK: --TF extensions
extension RegisterViewController: UITextFieldDelegate{
    
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
}

//MARK: -- image picker extenstion
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK -- imagePickerDelegate / navigationDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editableImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            selectedImage = editableImage
            
        }else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //set image
            selectedImage = image
            
        }
        
        if let selected = selectedImage{
            
            profileImage.image = selected
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

//MARK: -- pickerViewDataSource
extension RegisterViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 0:
            
            return states.count
        default:
            break
        }
        return 0
    }
}

//MARK: -- pickerDidSelectRow
extension RegisterViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 0:
            //set row of PV
            return states[row]
        default:
            break
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
            
        case 0:
            //set text with state selected
            stateTF.text = states[row]

        default:
            break
        }
     
    }
    
    
    
}
