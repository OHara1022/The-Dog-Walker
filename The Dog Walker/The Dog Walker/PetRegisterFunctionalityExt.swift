//
//  PetRegisterFunctionalityExt.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/30/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit

extension PetRegisterViewController {
    
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
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        
        photoActionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }))
        
        
        photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //present action sheet
        present(photoActionSheet, animated: true, completion: nil)
    }
    
    //MARK -- imagePickerDelegate / navigationDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //get image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            //set image
            petImage.image = image
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
        petNameTF.delegate = self
        bdayTF.delegate = self
        breedTF.delegate = self
        medsTF.delegate = self
        vaccineTF.delegate = self
        specialInstructionTF.delegate = self
        emergenctContactTF.delegate = self
        emergencyPhoneTF.delegate = self
        vetTF.delegate = self
        vetPhoneTF.delegate = self
        
    }
    
    //MARK: --Date picker funtionality
    func datePickerValueChanged(sender:UIDatePicker) {
        
        //init dateFormatter
        let dateFormatter = DateFormatter()
        
        //set time to none
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        //set date format
        dateFormatter.dateFormat = "MM/dd/YYYY"
        
        //set textField to date picker selection
        bdayTF.text = dateFormatter.string(from: sender.date)
        
        //set textField text to holder string for saving
        dateHolderString = bdayTF.text!
        
        //dev
        print("BDAY HOLDER STRING" + " " + dateHolderString)
    }
    
    
    func pickerItem(title: String, textField: UITextField, selector: Selector){
        
        //done button for date picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: selector)
        let pickerInfo = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
        
        
        doneButton.tintColor = UIColor(red:0.00, green:0.60, blue:0.80, alpha:1.0)
        pickerInfo.tintColor = UIColor.black
        
        // if you remove the space element, the "done" button will be left aligned
        toolBar.setItems([pickerInfo, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        
    }
    
    //stop editing on date picker
    func doneDatePickerPressed(){
        self.view.endEditing(true)
    }
    
    
    
    
    
}
