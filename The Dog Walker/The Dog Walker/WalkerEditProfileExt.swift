//
//  WalkerEditProfileExt.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 7/20/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension WalkerEditProfileViewController{
    
    //MARK: --Keyboard editing functionality
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
 
    //MARK: -- tfDelegate
    func setTFDelegate(){
        //set TF delegate to self
        editFirstNameTF.delegate = self
        editLastNameTF.delegate = self
        editEmailTF.delegate = self
        editAddressTF.delegate = self
        editAptNumTF.delegate = self
        editCityTF.delegate = self
        editStateTF.delegate = self
        editZipCodeTF.delegate = self
        editPhoneNumTF.delegate = self
        editCompanyNameTF.delegate = self
    }
    
    
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

    
    
}

//MARK: --TF extensions
extension WalkerEditProfileViewController: UITextFieldDelegate{
    
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
        case editFirstNameTF:
            editLastNameTF.becomeFirstResponder()
            return true
            
        case editLastNameTF:
            editEmailTF.becomeFirstResponder()
            return true
            
        case editEmailTF:
            editAddressTF.becomeFirstResponder()
            return true
            
        case editAddressTF:
            editAptNumTF.becomeFirstResponder()
            return true
            
        case editAptNumTF:
            editCityTF.becomeFirstResponder()
            return true
            
        case editCityTF:
            editStateTF.becomeFirstResponder()
            return true
            
        case editStateTF:
            editZipCodeTF.becomeFirstResponder()
            return true
            
        case editZipCodeTF:
            editPhoneNumTF.becomeFirstResponder()
            return true
            
        case editPhoneNumTF:
            editCompanyNameTF.becomeFirstResponder()
            return true
            
        case editCompanyNameTF:
            self.view.endEditing(true)//dismiss keyboard
            return true
            
        default:
            break
        }
        //else return false
        return false
    }
}
