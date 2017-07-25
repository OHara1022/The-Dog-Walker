//
//  WalkerEditScheduleExt.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 7/20/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit

extension WalkerEditScheduleViewController: UITextFieldDelegate{
    
    
    //MARK: -- textFieldDelegate
    //call textfieldDidBeginEditing for keyboard functionality
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.activeField = textField
//    }
//    
//    //call textfieldDidEndEditing for keyboard functionality
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.activeField = nil
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        switch textField {
//        case editPetNameTF:
//            editSpecialInsTF.becomeFirstResponder()
//            return true
//        case editSpecialInsTF:
//            self.view.endEditing(true)
//            return true
//        default:
//            break
//        }
//        return false
//    }
    
}


extension WalkerEditScheduleViewController{
    
    func setTFDelegate(){
        
        editDateTF.delegate = self
        editTimeTF.delegate = self
        editDurationTF.delegate = self
//        editPetNameTF.delegate = self
//        editSpecialInsTF.delegate = self

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
    
    
    //MARK: --Date picker funtionality
    func timePickerValueChanged(sender:UIDatePicker) {
        
        //init timeFormatter
        let timeFormatter = DateFormatter()
        
        //set time to none
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        //set textField to time picker selection
        editTimeTF.text = timeFormatter.string(from: sender.date)
        
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
        editDateTF.text = dateFormatter.string(from: sender.date)
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
    func donePickerPressed(){
        //dismiss picker
        self.view.endEditing(true)
    }
    
}

extension WalkerEditScheduleViewController: UIPickerViewDataSource{
    
    //set components to return 1 section, each pickerView only has one section
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //set number of rows in component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //switch pickerView tag
        switch pickerView.tag {
            
        case 0:
            //set count of roles array
            return durations.count
            
        default:
            break
        }
        //else return 0
        return 0
    }
    
}

extension WalkerEditScheduleViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag  {
            
        case 0:
            
            switch durations[row] {
                
            case "15 Minutes":
                
                editPriceTF.text = "10"
                
            case "30 Minutes":
                
                editPriceTF.text = "20"
                
            case "60 Minutes":
                editPriceTF.text = "30"
                
            default:
                break
            }
            
            return durations[row]
            
        default:
            break
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //set endEditing to true, to dismiss pickerView
        //        self.view.endEditing(true)
        
        switch pickerView.tag {
            
        case 0:
            
            editDurationTF.text = durations[row]
            
        default:
            break
        }
    }
}

