//
//  OwnerEditPetExt.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 7/18/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension EditPetViewController{
    
    //MARK: -- image functionality
    func presentImgOptions(){
        
        //create action sheet
        let photoActionSheet = UIAlertController(title: "Pet Photo", message: nil, preferredStyle: .actionSheet)
        
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
            
            petImageView.image = selected
            
            //ref to store pet images
            let storageRef = Storage.storage().reference().child("petImages").child("\(userID!).jpeg")
            
            //compress images
            if let uploadImage = UIImageJPEGRepresentation(self.petImageView.image!, 0.6){
                
                //get data
                storageRef.putData(uploadImage, metadata: nil, completion: { (metadata, error) in
                    //check if create user failed
                    if let error = error{
                        //present alert failed
                        FieldValidation.textFieldAlert("Image Storage Error", message: error.localizedDescription, presenter: self)
                        //dev
                        print(error.localizedDescription)
                        return
                    }
                    
                    //get image url
                    if let petImgURL = metadata?.downloadURL()?.absoluteString{
                        //dev
                        print(petImgURL)
                        
                        //save image url
                        self.ref.child(self.petKey!).updateChildValues(["petImage": petImgURL])
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
        editPetName.delegate = self
        editPetBday.delegate = self
        editBreed.delegate = self
        editMeds.delegate = self
        editVaccines.delegate = self
        editSpecialIns.delegate = self
        editVetName.delegate = self
        editVetPhone.delegate = self
    }
}

extension EditPetViewController: UITextFieldDelegate{
    
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
        case editPetName:
            editPetBday.becomeFirstResponder()
            return true
            
        case editPetBday:
            editBreed.becomeFirstResponder()
            return true
            
        case editBreed:
            editVaccines.becomeFirstResponder()
            return true
            
        case editVaccines:
            editMeds.becomeFirstResponder()
            return true
        case editMeds:
            editSpecialIns.becomeFirstResponder()
            return true
        case editSpecialIns:
            editVetName.becomeFirstResponder()
            return true
        case editVetName:
            editVetPhone.becomeFirstResponder()
            return true
        case editVetPhone:
            self.view.endEditing(true)//dismiss keyboard
            return true
        default:
            break
        }
        
        return false
    }
    
}
