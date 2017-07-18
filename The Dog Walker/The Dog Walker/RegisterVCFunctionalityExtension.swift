//
//  RegisterVCFunctionalityExtension.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/29/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension RegisterViewController{
    
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
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        addressTF.delegate = self
        aptTF.delegate = self
        cityTF.delegate = self
        stateTF.delegate = self
        zipCodeTF.delegate = self
        phoneTF.delegate = self
        companyCodeTF.delegate = self
        companyNameTF.delegate = self
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
    
    //MARK: -- create user in FB functionality
    func createUser(_ user: User){
        
        //populate class w/ TF text
        let userInfo = Users(firstName: firstNameTF.text! as String, lastName: lastNameTF.text! as String, email: emailTF.text! as String, address: addressTF.text! as String, city: cityTF.text! as String, state: stateTF.text! as String, zipCode: zipCodeTF.text! as String, phoneNumber: phoneTF.text! as String, uid: user.uid, companyCode: companyCodeTF.text! as String)
        
        //check if apt # has value
        if aptTF.text != nil{
            //set value for apt #
            userInfo.aptNumber = aptTF.text! as String
        }
        
        //get ref to store images
        let storageRef = Storage.storage().reference().child("profileImages").child("\(user.uid).jpeg")
        
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
                    self.ref.child(users).child(user.uid).updateChildValues(["profileImage": profileImgURL])
                }
            })
        }
        
        //save & push data to FB DB
        ref.child(users).child(user.uid).setValue(["firstName": userInfo.firstName, "lastName": userInfo.lastName, "email": userInfo.email, "password": passwordTF.text! as String, "phoneNumber": userInfo.phoneNumber, "uid": userInfo.uid, "companyCode": userInfo.companyCode, "companyName": companyNameTF.text! as String, "address": userInfo.address, "city": userInfo.city, "state": userInfo.state, "zipCode": userInfo.zipCode, "aptNumber": userInfo.aptNumber])
    }
    
    //MARK: --state picker item setup
    func pickerItem(title: String, textField: UITextField, selector: Selector){
        
        //done button for date picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: selector)
        let pickerInfo = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
        
        //set button color
        doneButton.tintColor = UIColor(red:0.00, green:0.60, blue:0.80, alpha:1.0)
        pickerInfo.tintColor = UIColor.black
        
        // if you remove the space element, the "done" button will be left aligned
        toolBar.setItems([pickerInfo, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        
    }
    
    //dismiss on done
    func doneSelected(){
        //dismiss pickerView
        self.view.endEditing(true)
    }
    
    
}
