//
//  OwnerEditProfileExt.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 7/20/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//MARK: --extension
extension EditOwnerViewController{
    
    //MARK: -- image functionality
    func presentImgOptions(){
        
        //create action sheet
        let photoActionSheet = UIAlertController(title: "Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        //add actions
        photoActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //present action sheet
        present(photoActionSheet, animated: true, completion: nil)
    }
    
    
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
            
            //get ref to store images
            let storageRef = Storage.storage().reference().child("profileImages").child("\(userID!).jpeg")
            
            //compress image
            if let uploadImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.6){
                
                //store data
                storageRef.putData(uploadImage, metadata: nil, completion: { (metadata, error) in
                    //check if create user failed
                    if let error = error{
                        //present alert failed
                        FieldValidation.textFieldAlert("Image Storage Error", message: error.localizedDescription, presenter: self)
                        //dev
                        print(error.localizedDescription)
                        return
                    }
                    
                    //check string from image url
                    if let profileImgURL = metadata?.downloadURL()?.absoluteString{
                        //dev
                        print(profileImgURL)
                        //set ref to image url
                        self.ref.updateChildValues(["profileImage": profileImgURL])
                    }
                })
            }
            
        }
        
        //dismiss imagePickerVC
        dismiss(animated: true, completion: nil)
    }
    
    //dismiss image picker if canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss imagePickerVC
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -- keyboard editing functionality
    //reference used for this functionality:
    //https://spin.atomicobject.com/2014/03/05/uiscrollview-autolayout-ios/
    func keyboardDidShow(_ notification: Notification) {
        if let activeField = self.activeField, let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    //method to hide keyboard
    func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func setTFDelegate(){
        //set TF delegate to self
        editFirstName.delegate = self
        editLastName.delegate = self
        editEmail.delegate = self
        editAddress.delegate = self
        editAptNum.delegate = self
        editCity.delegate = self
        editState.delegate = self
        editZipCode.delegate = self
        editPhoneNum.delegate = self
        editEmergencyContact.delegate = self
        editEmergencyPhoneNum.delegate = self
    }
    
}


extension EditOwnerViewController: UITextFieldDelegate{
    
    //call textfieldDidBeginEditing for keyboard functionality
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    //call textfieldDidEndEditing for keyboard functionality
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case editFirstName:
            editLastName.becomeFirstResponder()
            return true
            
        case editLastName:
            editEmail.becomeFirstResponder()
            return true
            
        case editEmail:
            editAddress.becomeFirstResponder()
            return true
            
        case editAddress:
            editAptNum.becomeFirstResponder()
            return true
            
        case editAptNum:
            editCity.becomeFirstResponder()
            return true
            
        case editCity:
            editState.becomeFirstResponder()
            return true
            
        case editState:
            editZipCode.becomeFirstResponder()
            return true
            
        case editZipCode:
            editPhoneNum.becomeFirstResponder()
            return true
            
        case editPhoneNum:
            editEmergencyContact.becomeFirstResponder()
            return true
            
        case editEmergencyContact:
            editEmergencyPhoneNum.becomeFirstResponder()
            return true
            
        case editEmergencyPhoneNum:
            self.view.endEditing(true)//dismiss keyboard
            return true
        default:
            break
        }
        
        return false
    }
    
}
